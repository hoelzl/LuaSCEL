---
-- Created by IntelliJ IDEA.
-- User: tc
-- Date: Jan/19/12
-- Time: 20:43 
--
-- An implementation of SCEL in Lua.

require "utilities"

local util = _G.util

-- We need to wait so that the debugger in IDEA can connect...
-- util.sleep(0.2)
-- require "remdebug.engine"
-- remdebug.engine.start()

-- A dictionary containing all known components, indexed by
-- their uuid.
components = {}

-- The metatable for components
local component_metatable = {
    -- Allow immediate access to the methods in the `interface'
    -- table.
    __index = function (table, key)
        return table.interface[key]
    end
}

-- The initial component that exists when the robot is initialized.
initial_component = {
    name = "<initial-component>",
    uuid = util.uuid(),

    interface = {

        -- Generic accessors for tuple spaces.
        --
        put = function (self, tuple, location)
            local remote_component = self:resolve_location(location)
            remote_component.interface:local_put(tuple, self)
        end,

        get = function (self, pattern, location)
            local remote_component = self:resolve_location(location)
            remote_component.interface:local_get(pattern, self)
        end,

        qry = function (self, pattern, location)
            local remote_component = self:resolve_location(location)
            remote_component.interface:local_qry(pattern, self)
        end,

        -- Accessors for the local tuple space
        --
        local_put = function  (component, tuple, sender)
        -- Put 'tuple' into the local tuple space if the policy allows it.
            local tuples = component.knowledge_base
            local policy = component.policy
            if (policy:allow_put_access(tuple, sender)) then
                tuples[#tuples + 1] = tuple
                return true
            else
                return nil
            end
        end,

        local_get = function (component, pattern, sender)
        -- Get a tuple matching 'pattern' from the local tuple space, if
        -- the policy agrees.
            -- local tuples = component.knowledge_base
            local policy = component.policy
            if (policy:allow_get_access(pattern, sender)) then
                return component:match_tuple(pattern)
            end
        end,

        local_qry = function (component, pattern, sender)
        -- Query the local tuple space for 'pattern' if the policy allows
        -- it.
            local tuples = component.knowledge_base
            local policy = component.policy
            if (policy:allow_qry_access(pattern, sender)) then
                return component:match_tuple(pattern)
            end
        end,

        -- Execution of programs
        --
        exec = function (process)
        -- add process to list of coroutines for self and yield
        end,

        new = function (name, interface, kb, policy, process)
            local new_component = {
                name = name,
                interface = interface,
                knowledge_base = kb,
                policy = policy,
                process = process
            }
            setmetatable(new_component, component_metatable)
            components[#components] = new_component
            return new_component
        end,

        -- Handling of names
        --
        register_local_name = function(component, name, named_component)
            component.names[name] = named_component
        end

    },

    knowledge_base = {},
    names = {},

    -- The policies.
    --
    policy = {
        allow_put_access = function (self, tuple, sender)
            return true
        end,
        allow_get_access = function (self, tuple, sender)
            return true
        end,
        allow_qry_access = function (self, tuple, sender)
            return true
        end
    },

    -- The processes running on this component.
    -- Actually a list of co-routines with the initial process acting as scheduler.
    --
    processes = {},

    -- Function used in the implementation of the component, but
    -- these functions should actually not be externally accessible.
    --
    match_tuple = function (self, pattern)
        -- Returns the index of a tuple matching pattern or false if no
        -- such tuple exists in the tuple space
        if type(pattern) == "string" then
            return self.knowledge_base[pattern]
        else
            return nil
        end
    end,

    resolve_location = function (self, location)
        if location == "self" then
            return self
        else
            return components[self.names[location]] or components[location]
        end
    end,
}

setmetatable(initial_component, component_metatable)
components[initial_component.uuid] = initial_component
