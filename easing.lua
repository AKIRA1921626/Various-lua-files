local M = {}

function M.linear(t) return t end
function M.inSine(t) return 1 - math.cos(t * (math.pi / 2)) end
function M.inQuad(t) return t * t end
function M.inCubic(t) return t * t * t end
function M.inQuart(t) return t * t * t * t end
function M.inQuint(t) return t * t * t * t * t end
function M.inCirc(t) return 1 - math.sqrt(1 - t * t) end
function M.inExpo(t) return (t == 0) and 0 or 2^(10 * (t - 1)) end
function M.inBack(t) local s = 1.70158 return t * t * ((s + 1) * t - s) end
function M.inElastic(t) if t == 0 or t == 1 then return t end local p = 0.3 local s = p / 4 local f = t - 1 return -(2^(10 * f) * math.sin((f - s) * (2 * math.pi) / p)) end
function M.inBounce(t) return 1 - M.outBounce(1 - t) end
function M.outSine(t) return math.sin(t * (math.pi / 2)) end
function M.outQuad(t) return t * (2 - t) end
function M.outCubic(t) local f = t - 1 return f * f * f + 1 end
function M.outQuart(t) local f = t - 1 return 1 - (f * f * f * f) end
function M.outQuint(t) local f = t - 1 return f * f * f * f * f + 1 end
function M.outCirc(t) return math.sqrt(1 - (t - 1)^2) end
function M.outExpo(t) return (t == 1) and 1 or 1 - 2^(-10 * t) end
function M.outBack(t) local s = 1.70158 local f = t - 1 return f * f * ((s + 1) * f + s) + 1 end
function M.outElastic(t) if t == 0 or t == 1 then return t end local p = 0.3 local s = p / 4 return 2^(-10 * t) * math.sin((t - s) * (2 * math.pi) / p) + 1 end
function M.outBounce(t) if t < (1 / 2.75) then return 7.5625 * t * t elseif t < (2 / 2.75) then t = t - (1.5 / 2.75) return 7.5625 * t * t + 0.75 elseif t < (2.5 / 2.75) then t = t - (2.25 / 2.75) return 7.5625 * t * t + 0.9375 else t = t - (2.625 / 2.75) return 7.5625 * t * t + 0.984375 end end
function M.inOutSine(t) return 0.5 * (1 - math.cos(math.pi * t)) end
function M.inOutQuad(t) t = t * 2 if t < 1 then return 0.5 * t * t else t = t - 1 return -0.5 * (t * (t - 2) - 1) end end
function M.inOutCubic(t) t = t * 2 if t < 1 then return 0.5 * t * t * t else t = t - 2 return 0.5 * (t * t * t + 2) end end
function M.inOutQuart(t) t = t * 2 if t < 1 then return 0.5 * t * t * t * t else t = t - 2 return -0.5 * (t * t * t * t - 2) end end
function M.inOutQuint(t) t = t * 2 if t < 1 then return 0.5 * t * t * t * t * t else t = t - 2 return 0.5 * (t * t * t * t * t + 2) end end
function M.inOutCirc(t) t = t * 2 if t < 1 then return -0.5 * (math.sqrt(1 - t * t) - 1) else t = t - 2 return 0.5 * (math.sqrt(1 - t * t) + 1) end end
function M.inOutExpo(t) if t == 0 or t == 1 then return t end t = t * 2 if t < 1 then return 0.5 * 2^(10 * (t - 1)) else return 0.5 * (-(2^(-10 * (t - 1))) + 2) end end
function M.inOutBack(t) local s = 1.70158 * 1.525 t = t * 2 if t < 1 then return 0.5 * (t * t * ((s + 1) * t - s)) else t = t - 2 return 0.5 * (t * t * ((s + 1) * t + s) + 2) end end
function M.inOutElastic(t) if t == 0 or t == 1 then return t end local p = 0.3 * 1.5 local s = p / 4 t = t * 2 - 1 if t < 0 then return -0.5 * (2^(10 * t) * math.sin((t - s) * (2 * math.pi) / p)) else return 2^(-10 * t) * math.sin((t - s) * (2 * math.pi) / p) * 0.5 + 1 end end
function M.inOutBounce(t) if t < 0.5 then return M.inBounce(t * 2) * 0.5 else return M.outBounce(t * 2 - 1) * 0.5 + 0.5 end end

return M