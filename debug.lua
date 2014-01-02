Debug = Class:extend
{
   -- filename = "log.txt",
   hide = { _cache = 0, _lookup = 0, _inits = 0, _tree = 0, _modules = 0 },
   file = nil
}

function Debug:cross(obj, rec, offset, lookup, cond)
    local offset = offset or 0
    local lookup = lookup or { }

    if obj == nil then io.write('nil\n'); return ; end

    rec = rec or 1
    for key, val in self:_pairs_by_keys(obj) do
        if cond == nil or cond(self, key, val) then
            self:_draw(key, val, offset)
        end

        if rec and rec ~= 0 and type(val) == 'table' and self.hide[key] == nil then
            self:_draw(key, val, offset)

            if lookup[val] == nil then
                lookup[val] = val
                self:cross(val, rec - 1, offset + 1, lookup, cond)
            end
        end
    end
end

function Debug:cond_attr(key, val)
    return type(val) ~= 'function' and type(val) ~= 'table'
end

function Debug:cond_fct(key, val)
    return type(val) == 'function' and type(val) ~= 'table'
end

function Debug:object(obj, rec)
    self:cross(obj, rec or 1, offset or 0, lookup or { })
end

function Debug:attrs(obj, rec)
    self:cross(obj, rec or 1, offset or 0, lookup or { }, Debug.cond_attr)
end

function Debug:fcts(obj, rec)
    self:cross(obj, rec or 1, offset or 0, lookup or { }, Debug.cond_fct)
end

function Debug:write(...)
    for i, message in pairs { ... } do
        self:log(tostring(message))
    end

    self:log("\n")
end

function Debug:write_part(...)
    for i, message in pairs { ... } do
        self:log(tostring(message))
    end
end

function Debug:log(message, max)
    if self.filename then
        if self.file == nil then
            self.file = io.open(self.filename, "w")
        end

        self.file:write(self:_pad(message, max))
    else
        io.write(self:_pad(message, max))
    end
end

-- private

function Debug:_pad(word, max)
    local size = string.len(word)
    local max = max or 0

    while (size < max) do
        word = word .. ' '
        size = size + 1
    end

    return word
end

function Debug:_draw(key, val, offset)
    while offset > 0 do
        self:log('\t')
        offset = offset - 1
    end

    if type(val) == 'boolean' then
        self:log(self:_pad('[' .. tostring(key) .. ']') .. ' -> ' .. type(val) .. ': ' .. (val == true and 'true' or 'false') .. '\n')
    elseif type(val) == 'number' then  
        self:log(self:_pad('[' .. tostring(key) .. ']') .. ' -> ' .. type(val) .. ': ' .. val .. '\n')
    elseif type(val) ~= 'function' and type(val) ~= 'table' then
        self:log(self:_pad('[' .. tostring(key) .. ']') .. ' -> ' .. type(val) .. ': "' .. val .. '"\n')
    else
        self:log(self:_pad('[' .. tostring(key) .. ']') .. ' -> ' .. tostring(val) .. '\n')
    end
end

function Debug:_pairs_by_keys(t)
    local a = {}
    
    for n in pairs(t) do 
        if type(n) ~= 'table' then
            table.insert(a, n) 
        end
    end

    table.sort(a)

    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1

        if a[i] == nil then 
            t = nil
            a = nil

            return nil
        else 
            return a[i], t[a[i]]
        end
    end

    return iter
end