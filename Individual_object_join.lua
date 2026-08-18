--[[
Individual_object_join.lua
個別オブジェクトを1つの単一オブジェクトとして統合するモジュール。
]]

local M = {}

function M.object_join(add_w,add_h)
    add_w = add_w or 0
    add_h = add_h or 0

    -- index 0 の時にバッファを初期化
    if (obj.index == 0) then

            -- 改行の有無を確認する
        local text = obj.getvalue("テキスト","テキスト")
        local count = 1
        local i = 0
        while true do
            -- 改行の位置を検索
            i = string.find(text, "\\n", i + 1)
            if not i then break end
    
            -- 直前の文字を確認（インデックス i-1）
            local prev_char = string.sub(text, i - 1, i - 1)
    
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
        local tw,th = obj.load("textlayout",text)
        -- 現在のテキストオブジェクトでの改行の縦と横を取得。ここで各種座標がリセットされる。
        local ew,eh = obj.load("textlayout","\n")

        -- obj.load()の座標リセットを回避するため、座標保存用の変数を再度各座標に格納。
        obj.ox = ox
        obj.oy = oy
        obj.oz = oz
        obj.cx = cx
        obj.cy = cy
        obj.cz = cz
    
        -- 改行のサイズと改行が行われている回数を掛け合わせたものを変数に格納
        local line_break_offset = ew * eh * count

        -- 最終的に仮想バッファに渡すw,hの変数
        local finalsize_w = math.min(obj.screen_w,(tw-line_break_offset + add_w))
        local finalsize_h = math.min(obj.screen_h,(th*count + add_h))

        -- 仮想バッファの作成（初期化）
        obj.setoption("drawtarget", "tempbuffer", finalsize_w, finalsize_h)
        obj.clearbuffer("tempbuffer")
    else
        -- 2文字目以降は既存のバッファをターゲットに設定
        obj.setoption("drawtarget", "tempbuffer")
    end

    -- 拡大率と透明度の取得
    -- ※AviUtlの内部仕様により obj.sx 等を統合して扱う
    local scale = obj.sx
    local alpha = obj.getvalue("alpha")

    -- 仮想バッファへの描画
    obj.draw(obj.ox, obj.oy, obj.oz, scale, alpha, obj.rx, obj.ry, obj.rz)

    -- 最後の文字ではない場合：元の文字を表示させないための処理
    if (obj.index ~= obj.num - 1) then
        obj.setoption("drawtarget", "framebuffer")
        obj.load("tempbuffer") -- バッファをロード
        obj.alpha = 0
        obj.draw(obj.ox, obj.oy, obj.oz, scale, 0, obj.rx, obj.ry, obj.rz)
    else
        -- 最後の文字の場合：統合されたバッファをメインに描画
        obj.setoption("drawtarget", "framebuffer")
        obj.load("tempbuffer")
        obj.clearbuffer("tempbuffer")
        -- 描画後は他のスクリプトへの影響を防ぐためバッファをクリア
        -- ただし、直後に obj.draw() が呼ばれることを前提とする
        -- obj.clearbuffer("tempbuffer") -- 必要に応じてコメント解除
    end
end

return M