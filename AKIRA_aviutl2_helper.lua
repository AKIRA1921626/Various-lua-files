--[[
AKIRA作のAviutl2で使用する目的の各種モジュール。
]]

local M = {}

function M.line_break_confirmation() -- 現在のテキストで改行が行われた回数を確認する関数
        -- 改行の有無を確認する
        local text = obj.getvalue("テキスト","テキスト")
        local count = 1 -- ここの数値が改行が行われている回数となる。
        local i = 0
        while true do
            -- 改行の位置を検索
            i = string.find(text, "\\n", i + 1)
            if not i then break end

            -- 直前の文字を確認（インデックス i-1）
            local prev_char = string.sub(text, i - 1, i - 1,true)

            if prev_char ~= "\\" then
                count = count + 1
            end
        end
        return count -- 現在のテキストで改行が行われた回数を返す
end

function M.get_line_break_size() -- 現在のテキストでの改行のサイズを取得する関数
    -- objload("textlayout",text)用に各種値を取得し設定
    local name = obj.getvalue("テキスト","フォント")
    local size = obj.getvalue("テキスト","サイズ")
    local charspacing = obj.getvalue("テキスト","字間")
    local linespacing = obj.getvalue("テキスト","行間")

    -- setfontに渡す引数の値をマジックナンバーを回避するために変数として作成
    local type,col1,col2,bold,italic = 0,0x000000,0x000000,false,false
    obj.setfont(name,size,type,col1,col2,bold,italic,charspacing,linespacing)

    -- obj.load()の座標リセットを回避するため、座標保存用の変数
    local ox,oy,oz,cx,cy,cz = obj.ox,obj.oy,obj.oz,obj.cx,obj.cy,obj.cz

    local lw,lh = obj.load("textlayout","\\n")

    -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
    obj.ox = ox
    obj.oy = oy
    obj.oz = oz
    obj.cx = cx
    obj.cy = cy
    obj.cz = cz

    return lw,lh -- 現在のテキストでの改行のサイズを返す
end

function M.get_text_size() -- 現在のテキスト全体のサイズを取得する関数
    -- objload("textlayout",text)用に各種値を取得し設定
    local name = obj.getvalue("テキスト","フォント")
    local size = obj.getvalue("テキスト","サイズ")
    local charspacing = obj.getvalue("テキスト","字間")
    local linespacing = obj.getvalue("テキスト","行間")

    -- setfontに渡す引数の値をマジックナンバーを回避するために変数として作成
    local type,col1,col2,bold,italic = 0,0x000000,0x000000,false,false
    obj.setfont(name,size,type,col1,col2,bold,italic,charspacing,linespacing)

    -- テキストオブジェクトの中身を取得
    local text = obj.getvalue("テキスト","テキスト")

    -- obj.load()には obj.ox, obj.oy, obj.​cx などが 0 に初期化されるというしようがあるらしい。
    -- https://x.com/sigma_axis/status/2023330969777012820
    -- そのためobj.load("textlayout",text)を使用する前に、各種座標を保存しておく。

    -- obj.load()の座標リセットを回避するため、座標保存用の変数
    local ox,oy,oz,cx,cy,cz = obj.ox,obj.oy,obj.oz,obj.cx,obj.cy,obj.cz

    -- テキストオブジェクトの実際の中身の縦と横を取得。ここで各種座標がリセットされる。
    local w,h = obj.load("textlayout",text)

    -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
    obj.ox = ox
    obj.oy = oy
    obj.oz = oz
    obj.cx = cx
    obj.cy = cy
    obj.cz = cz

    return w,h -- 現在のテキスト全体のサイズを返す
end

function M.get_text_resize() -- 現在のテキストに合わせたリサイズに使う数値を返す
    -- 改行の有無を確認する
    local text = obj.getvalue("テキスト","テキスト")
    local count = 1 -- ここの数値が改行が行われている回数となる。
    local i = 0
    while true do
        -- 改行の位置を検索
        i = string.find(text, "\\n", i + 1)
        if not i then break end

        -- 直前の文字を確認（インデックス i-1）
        local prev_char = string.sub(text, i - 1, i - 1,true)

        if prev_char ~= "\\" then
            count = count + 1
        end
    end

            -- objload("textlayout",text)用に各種値を取得し設定
    local name = obj.getvalue("テキスト","フォント")
    local size = obj.getvalue("テキスト","サイズ")
    local charspacing = obj.getvalue("テキスト","字間")
    local linespacing = obj.getvalue("テキスト","行間")

    -- setfontに渡す引数の値をマジックナンバーを回避するために変数として作成
    local type,col1,col2,bold,italic = 0,0x000000,0x000000,false,false
    obj.setfont(name,size,type,col1,col2,bold,italic,charspacing,linespacing)

    -- テキストオブジェクトの中身を取得
    local text = obj.getvalue("テキスト","テキスト")

    -- obj.load()には obj.ox, obj.oy, obj.​cx などが 0 に初期化されるというしようがあるらしい。
    -- https://x.com/sigma_axis/status/2023330969777012820
    -- そのためobj.load("textlayout",text)を使用する前に、各種座標を保存しておく。

    -- obj.load()の座標リセットを回避するため、座標保存用の変数
    local ox,oy,oz,cx,cy,cz = obj.ox,obj.oy,obj.oz,obj.cx,obj.cy,obj.cz

    -- テキストオブジェクトの実際の中身の縦と横を取得。ここで各種座標がリセットされる。
    local w,h = obj.load("textlayout",text)

    -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
    obj.ox = ox
    obj.oy = oy
    obj.oz = oz
    obj.cx = cx
    obj.cy = cy
    obj.cz = cz

    -- リサイズの数値の計算
    local resize
    resize = (h/100) / math.max(1,count)

return resize -- 現在のテキストに合わせたリサイズの数値
end

function M.single_line_size_for_resizing_the_shape() -- 図形をリサイズする時のためのテキストの1行のサイズを取得
    local w_l,w_h = M.get_text_size()
    local f_l,f_h =  w_l / M.line_break_confirmation(),w_h / M.line_break_confirmation()
    return f_l,f_h
end

function M.characters_size_for_resizing_the_shape() -- 図形をリサイズする時のための個別オブジェクト時のテキストの各文字のサイズを取得

    local is_multi = obj.getoption("multi_object")
    local idx = obj.index + 1

    -- 元のテキスト部分のサイズと中心座標
    local txt_w, txt_h = 0, 0
    local raw_cx, raw_cy = 0, 0 -- 中心座標 この関数では返していないため、今は不要

    -- 最初の文字の時のみここを実行
    if (idx - 1) == 0 then
        -- 個別文字の座標を保存しておくグローバル変数
        _G.AKIRA_HELPER_CHARS = {}
    end

    -- 文字ごとのサイズ・位置情報を記憶
    _G.AKIRA_HELPER_CHARS[idx] = { ox = obj.ox, oy = obj.oy, w = obj.w, h = obj.h }

    local min_x, max_x = 999999, -999999
    local min_y, max_y = 999999, -999999
    local found = false
    local last_c = obj.num
    for i = idx, last_c do
        local c_info = _G.AKIRA_HELPER_CHARS and _G.AKIRA_HELPER_CHARS[i]
        if c_info then
            local hw = c_info.w / 2
            local hh = c_info.h / 2
            min_x = math.min(min_x, c_info.ox - hw)
            max_x = math.max(max_x, c_info.ox + hw)
            min_y = math.min(min_y, c_info.oy - hh)
            max_y = math.max(max_y, c_info.oy + hh)
            found = true
        end
    end
    if found then
        txt_w = max_x - min_x  -- 対象文字群の全体の幅
        txt_h = max_y - min_y  -- 対象文字群の全体の高さ
        raw_cx = (min_x + max_x) / 2 -- 中心座標 この関数では返していないため、今は不要
        raw_cy = (min_y + max_y) / 2 -- 中心座標 この関数では返していないため、今は不要
    end

    return txt_w,txt_h -- 個別オブジェクト時のテキストの縦と横を、図形をリサイズするようにした数値を返す。
end

function M.create_screen_tempbuffer() -- スクリーンサイズで仮想バッファを作成する関数
    obj.setoption("drawtarget","tempbuffer",obj.screen_w,obj.screen_h)
end

-- テキストを改行ごとに分割し、内容を配列テーブルとして返す関数
function M.get_lines_from_text()
    local text = obj.getvalue("テキスト", "テキスト")
    local lines = {}

    if not text then
        return lines
    end

    -- 改行コード(\\r\\n または \\n)で区切ってテーブルへ格納
    for line in text:gmatch("[^\\r\\n]+") do
        table.insert(lines, line)
    end

    return lines
end

-- 引数strに渡された文字列からサイズw,hを取得する関数
function M.get_string_size(str)
    if not str then
        return 0
    end

    -- "text.layout"は、現在のオブジェクトに影響を与えず、次の引数(今回はstr)のw,hを返す。
    local w,h = obj.load("text.layout",str)

    return w,h
end

-- 各行のサイズ一覧を配列テーブルとして取得する関数
function M.get_line_sizes()
    local lines = M.get_lines_from_text()
    local sizes = {}

    for i = 1, #lines do
        local t = M.get_lines_from_text()
        local w,h = obj.load("text.layout",t[i])
        table.insert(sizes, {w,h})
    end

    return sizes
end

return M