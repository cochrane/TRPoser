TRStructure System Overview
===========================

The main goals of the TR reading framework here were the following:

*	All fields captured and saved
*	Can write all data back to file
*	Every structure is an object
*	No interpretation in reading., except all ints get mapped to NS(U)Integer,
	all floats to double.
*	Deriving of scaled values, attributes, objects from indices and so on happen
	in accessors that read/write the underlying original field.

This requires a lot of annoying work. TRStructure is a system to avoid most of 
this by adding its own domain-specific language and generic code for many general
things. A simple example is TR1RoomPortal:

	#import <Foundation/Foundation.h>

	#import "TRStructure.h"

	@class TR1Vertex;
	@class TR1Room;

	@interface TR1RoomPortal : TRStructure

	@property (nonatomic, assign) NSUInteger otherRoomIndex;
	@property (nonatomic, retain) TR1Vertex *normal;
	@property (nonatomic, copy) NSArray *vertices;

	// Derived properties
	@property (nonatomic, weak) TR1Room *otherRoom;

	@end

With the implementation

	@implementation TR1RoomPortal

	+ (NSString *)structureDescriptionSource
	{
		return @"bitu16 otherRoomIndex;\
		TR1Vertex normal;\
		TR1Vertex vertices[4];\
		@derived otherRoom=level.rooms[otherRoomIndex];";
	}

	@dynamic otherRoom;

	@end

All the reading and writing of the portal is handled by the TRStructure base
class, based on the fields in the structure description. It also automatically
generates the otherRoom and setOtherRoom: methods.

A quick note: It will not generate classes for you, and there are a lot of
things this language could do but doesn't, typically because writing the method
for this yourself is easier. This is by design. The standard pattern is that
you subclass TRStructure or something that subclasses it, and then override
`+structureDescriptionSource` and implement your own custom logic.

For almost any classes, it is enough to override the +structureDescriptionSource
method, so let's discuss the source.

Normal Fields
-------------

Normal fields read a few bytes from the file and put them in a property in your
class. A normal field has the format

	type name;
	
Where type is one of `bit[u][8|16|32]`, or a class name. There is no way to
declare nested types, structs and so on, because, as mentioned above, everything
is a class. `name` is the name of a valid key (according to KVC) in the class
that specified this type.

If the type is a class name, then it has to implement

	- (id)initFromDataStream:(TRInDataStream *)stream inLevel:(TR1Level *)level;
	- (void)writeToStream:(TROutDataStream *)stream;

All classes that derive from TRStructure already do so, but of course, any other
class can do this as well. 

(__not yet implemented__): If the
class name starts with a *, then the implementation will try to find a class
matching the version number of the level. E.g. if the level has a version of 4
and the field is

	*Thingy thingy;
	
then the class will try TR4Thingy, TR3Thingy, TR2Thingy and TR1Thingy, in that
order, and use the first one that actually exists.

A field can also be an array:

	type name[constant];
	type name[bitu16];
	
The first case is an array of constant length. The second is the pattern where a
field immediately preceding the array says how long it will be. Specify the type
of this count field in the brackets. The count field must not get its own field
declaration. Type can be both a class or a primitive type, but primitive types
get wrapped in NSNumbers and stored in an NSArray, which may or may not be what
you want.

I'm considering adding something like

	type name[key];

Where key is something that can be gotten with KVC.

In all cases, for reading the value, setValue:forKey: is used, and for writing,
the value is gathered with valueForKey:

### Const fields ###

A field can be const and is then declared as

	const bitu32=45;

A const field has no name and doesn't store its value. If, on reading, the file
has a different value, it throws an exception. On writing, it always outputs the
expected value.

Derived properties
------------------

Derived properties can be declared in any order. They handle the implementation
of many standard methods. In all cases, they create new set<Key>: and <key>
methods. They access the underlying values via valueForKey: and setValueForKey:,
so they can totally reference each other, or other accessors you wrote yourself.
As a side-effect, if you declare them as a property, the implementation should
always list them as @dynamic.

### Index fields ###

A common example is that a field is an index into an array. A derived field gets
the object from that array, and on setting, updates the index. This looks like
this:

	@derived object=array[index];

Array is a key-value path starting at the object. Typically, it will be
something like level.rooms to get the rooms of the array. For setting the value,
indexOfObject is sent to this array.

I'm still considering adding a syntax to have certain values specifiy nil.

The system automatically generates the setObject: and object methods. Therefore,
if this is declared as a property in the interface, the implementation has to
declare them as `@dynamic`.

Note that index can be anything accessed via KVC, as long as it returns
something that responds to unsignedIntegerValue (if called via KVC). Thus, it
can also be a factor field, bit field or similar.

### Factor fields ###

Scales a value by a constant factor, to make things more friendly (e.g. angles).

	@factor scaled=base*5;
	@factor(unsigned) scaled=base/5;
	
Basically like this. The type can be specified as signed, unsigned or double, it
defaults to double. It's always base first, then the constant factor.

Note that base can be anything accessed via KVC, as long as it returns
something that responds to unsignedIntegerValue (if called via KVC). Thus, it
can also be another factor field, bit field or similar.

__division is not yet there!__

### Bit fields (not yet implemented) ###

	@bitfield angle=rotation & 0xCF00

Automatically shifts the thing down and up. Result is NSUInteger for anything
more than one bit, BOOL for anything else.


Special notes for complicated things
------------------------------------

A Tomb Raider level is huge, so it uses multiple descriptions in a manner unique
to it. The derived properties from all descriptions get added to the level; but
parsing happens piece by piece. This is simply done by providing its own
-initFromStream: which does not call to TRStructure's implementation, and doing
internally what TRStructure does.