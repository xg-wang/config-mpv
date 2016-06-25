-- If the laptop is on battery, the VO set in the config will be choosen,
-- else the one defined with „hqvo“ is used.
local hqvo = "vo=opengl-hq:scale=ewa_lanczossharp:cscale=ewa_lanczossoft:dscale=mitchell:tscale=triangle:scale-antiring=0.8:cscale-antiring=0.9:dither-depth=auto:target-prim=bt.709:correct-downscaling=yes"
local utils = require 'mp.utils'
if mp.get_property_bool("option-info/vo/set-from-commandline") == true then
    return
end
t = {}
t.args = {"/usr/bin/pmset", "-g", "ac"}
res = utils.subprocess(t)
if res.stdout ~= "No adapter attached.\n" then
    mp.set_property("options/vo", hqvo)
    -- to activate interpolation
    -- mp.set_property("options/video-sync", "display-resample")
end
