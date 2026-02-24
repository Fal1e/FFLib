FFLib.Cam3D2D = {}

function FFLib.Cam3D2D:Draw(func, pos, ang, scale)
    cam.Start3D2D(pos, ang, scale)
        pcall(func)
    cam.End3D2D()
end