module handle;

struct Handle
{
	uint index;
	uint generation;
}

fn bool Handle.is_valid(&self) @inline
{
	return self.index != 0 && self.generation != 0;
}

module handle_pool<Type>;

import std::io;
import std::collections::list;
import handle;

struct HandlePool
{
	List{ Slot } slots;
	List{ uint } free_list;
}

struct Slot
{
	Type value;
	uint generation;
	bool alive;
}

fn void HandlePool.init(&self, Allocator alloc = mem) 
{
	self.slots.init(alloc);
	self.free_list.init(alloc);

	// index 0 is reserved as invalid-index
	self.slots.push((Slot){});
}

fn void HandlePool.free(&self)
{
	self.slots.free();
	self.free_list.free();
}

fn Handle HandlePool.create(&self)
{
	uint index;
	if (!self.free_list.is_empty())
	{
		// shouldn't get triggered since we check if empty
		index = self.free_list.pop()!!;
	}
	else
	{
		self.slots.push((Slot){
			.generation = 1,
			.alive = false,
		});
		index = (uint)(self.slots.len() - 1);
	}

	Slot* slot = &self.slots[index];
	slot.alive = true;

	return (Handle){
		.index = index,
		.generation = slot.generation,
	};
}

fn void HandlePool.destroy(&self, Handle handle)
{
	if (!handle.is_valid()) return;
	if (!self.is_valid(handle)) return;

	Slot* slot = &self.slots[handle.index];
	slot.alive = false;
	slot.generation++;
	self.free_list.push(handle.index);
}

fn Type* HandlePool.get(&self, Handle handle)
{
	if (!self.is_valid(handle)) return null;
	return &self.slots[handle.index].value;
}

fn bool HandlePool.is_valid(&self, Handle handle)
{
	if (!handle.is_valid()) return false;
	if (handle.index >= self.slots.len()) return false;

	Slot* slot = &self.slots[handle.index];
	return slot.alive && slot.generation == handle.generation;
}

fn bool Handle.eq(&self, Handle other) @operator(==)
{
	return self.index == other.index && self.generation == other.generation;
}
