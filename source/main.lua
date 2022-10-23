
-- メイン

-- 基本ライブラリ
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- よく使う参照
local gfx <const> = playdate.graphics

-- とりあえずスプライト
local aSprite = nil

-- マイク入力レベル
local mic_level = 0.0
-- 表示サンプル位置（毎フレームでpos++）
local pos = 0

-- セットアップ定義
function MyGameSetUp()
    -- マイクをアクティブに
    playdate.sound.micinput.startListening()

    -- スプライト用イメージ
    local sprImage = gfx.image.new(400,100)

    -- スプライト初期化
    aSprite = gfx.sprite.new( sprImage )
    aSprite:moveTo(10, 10)
    aSprite:setCenter(0,0)
    aSprite:add()
end

-- update前のセットアップ実行
MyGameSetUp()

-- フレーム毎の更新処理
function playdate.update()
    -- 表示位置更新
    pos += 1
    if pos > 400 then
        pos = 0
    end

    -- 前回のレベルを保管
    local  mic_level_prev = mic_level
    -- マイク入力レベル取得
    mic_level = playdate.sound.micinput.getLevel()

    -- スプライト更新
    gfx.pushContext(aSprite:getImage())
    gfx.setColor(gfx.kColorClear)
    gfx.fillRect(pos, 0, 1, 100)
    if mic_level ~= mic_level_prev then
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRect(pos, 0, 1,100.0 * mic_level)
    end
    gfx.popContext()
    aSprite:markDirty()
    -- /スプライト更新

    -- 表示位置を移動（スプライトのテスト兼ねて）
    if playdate.buttonIsPressed( playdate.kButtonUp ) then
        aSprite:moveBy( 0, -2 )
    end
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        aSprite:moveBy( 2, 0 )
    end
    if playdate.buttonIsPressed( playdate.kButtonDown ) then
        aSprite:moveBy( 0, 2 )
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
        aSprite:moveBy( -2, 0 )
    end

    -- Playdateによる更新処理
    gfx.sprite.update()
    playdate.timer.updateTimers()
end

-- ロックボタン2回押しでアンロックした時
function playdate.deviceDidUnlock()
    -- マイク入力をアクティブにする（スリープで非アクティブ化されるため）
    playdate.sound.micinput.startListening()
end