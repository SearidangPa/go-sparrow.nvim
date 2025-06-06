local M = {}

local last_motion = {
  type = nil,
  direction = nil,
  count = nil,
}

function M.set_last_motion(motion_type, direction, count)
  last_motion.type = motion_type
  last_motion.direction = direction
  last_motion.count = count or 1
end

function M.get_last_motion()
  return last_motion.type, last_motion.direction, last_motion.count
end

function M.clear_last_motion()
  last_motion.type = nil
  last_motion.direction = nil
  last_motion.count = nil
end

function M.has_last_motion()
  return last_motion.type ~= nil and last_motion.direction ~= nil
end

return M