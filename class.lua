Class = 
{
    _cache = nil,
    _ctors = { },
    _tree = { }
}

function Class:extend(attrs)
    local class = self:clone()

    for key, val in pairs(attrs) do
        class[self:clone(key)] = self:clone(val)
    end

    if attrs._id then
        Factory:set(class, attrs._id)
    end

    if Notifier ~= nil then
        Notifier:add_observer(class, class.cache, "class_cache")
    end

    return class
end

function Class:implement(...)
    local class = self:clone()

    class._tree = { ... }

    return class
end

function Class:clone(object)
	local lookup_table = {}

    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}

        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end

        return setmetatable(new_table, getmetatable(object))
    end

    if object ~= nil then
        return _copy(object)
    else
        return _copy(self)
    end
end

function Class:new(attrs)
    local class, cache

    self:cache()

    cache = self._cache
    self._cache = nil

    class = self:clone(cache)
    self._cache = cache

    for key, val in pairs(attrs or { }) do
        class[key] = val
    end

    for i, ctor in pairs(class._ctors) do
        ctor(class)
    end

	return  class
end

function Class:cache()
    if self._cache == nil then
        local tree, ctors = { }, { }
        local class = self:clone(Class)
        local parent

        for key, val in pairs(self._tree) do
            tree[val] = val
        end

        for i, class_id in pairs(self._tree) do
            parent = Factory:get(class_id):cache()

            for key, val in pairs(parent) do
                class[self:clone(key)] = self:clone(val)
            end

            for j, parent_id in pairs(parent._tree) do
                tree[parent_id] = parent_id
            end

            for j, ctor in pairs(parent._ctors) do
                ctors[#ctors + 1] = ctor
            end
        end

        for key, val in pairs(self) do
            class[self:clone(key)] = self:clone(val)
        end

        ctors[#ctors + 1] = self._init or nil
        
        if self._id then
            tree[self._id] = self._id
        end

        class._tree = tree
        class._ctors = ctors

        self._cache = class
    end

    return self._cache
end

function Class:is_a(class_id)
    return self._tree[class_id] ~= nil
end