local Easing = require("easing")

local M = {}

local mode_map = {
    [0]="linear",[1]="inSine",[2]="inQuad",[3]="inCubic",[4]="inQuart",[5]="inQuint",
    [6]="inCirc",[7]="inExpo",[8]="inBack",[9]="inElastic",[10]="inBounce",
    [11]="outSine",[12]="outQuad",[13]="outCubic",[14]="outQuart",[15]="outQuint",
    [16]="outCirc",[17]="outExpo",[18]="outBack",[19]="outElastic",[20]="outBounce",
    [21]="inOutSine",[22]="inOutQuad",[23]="inOutCubic",[24]="inOutQuart",[25]="inOutQuint",
    [26]="inOutCirc",[27]="inOutExpo",[28]="inOutBack",[29]="inOutElastic",[30]="inOutBounce"
}

-- 登場順の計算
function M.get_order(entry_order)
    if entry_order < 1 then return obj.index end
    if entry_order < 2 then return obj.num - 1 - obj.index end
    if entry_order < 3 then
        local center = (obj.num - 1) / 2
        return math.abs(center - obj.index)
    end
    if entry_order < 4 then
        local idx = {}
        for i = 0, obj.num - 1 do idx[i + 1] = i end
        local seed = obj.id
        for i = 1, obj.num do
            local dest = obj.rand(0, obj.num - 1, seed, i)
            local target = dest + 1
            idx[i], idx[target] = idx[target], idx[i]
        end
        return idx[obj.index + 1]
    end
    local center = (obj.num - 1) / 2
    return center - math.abs(center - obj.index)
end

-- イージングの適用（ease_t と out_ease_t を返す）
function M.calc_ease(params)
    local order = M.get_order(params.entry_order or 0)
    local mode = mode_map[params.entry_easing] or "linear"
    local delay = params.entry_delay or 0.3
    local in_len = (params.entry_time or 0.3) + (params.in_time or 0)
    local out_len = (params.entry_time or 0.3) + (params.out_time or 0)

    local ease_t = 0
    local out_ease_t = 0

    if (params.entry_in or 0) ~= 0 then
        local my_delay_time = order * delay
        if in_len > 0 then
            local progress = (in_len - (obj.time - my_delay_time)) / in_len
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
            ease_t = Easing[mode](progress)
        else
            ease_t = (obj.time - my_delay_time >= 0) and 0 or 1
        end
    end

    if (params.entry_out or 0) ~= 0 then
        local my_out_delay_time = order * delay
        local out_start_trigger = obj.totaltime - out_len - my_out_delay_time
        if out_len > 0 then
            local out_progress = (obj.time - out_start_trigger) / out_len
            if out_progress < 0 then out_progress = 0 end
            if out_progress > 1 then out_progress = 1 end
            out_ease_t = Easing[mode](out_progress)
        else
            out_ease_t = (obj.time >= out_start_trigger) and 1 or 0
        end
    end

    return ease_t, out_ease_t
end

-- フェード処理
function M.apply_fade(params)
    local in_fade_speed = 0
    local out_fade_speed = 0
    if (params.entry_in_fade or 0) ~= 0 then in_fade_speed = (params.in_fade_time or 0) end
    if (params.entry_out_fade or 0) ~= 0 then out_fade_speed = (params.out_fade_time or 0) end
    obj.effect("フェード", "イン", in_fade_speed, "アウト", out_fade_speed)
end

return M