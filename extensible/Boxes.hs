{-# LANGUAGE  TupleSections, ViewPatterns #-}

module Boxes where
import Graphics.UI.SDL hiding (update,Rect,Color,Event)
import qualified Graphics.UI.SDL as SDL
type Point     = (Double,Double) -- in pixels

data Rect    = Rect {leftup :: Point, rightdown :: Point} deriving Show
data Color   = Color {  r :: Double, g :: Double, b :: Double} deriving Show
data Box     = Box Rect Color deriving Show


normalize (Rect (lx,uy) (rx,dy)) = Rect (min lx rx, min uy dy) (max lx rx, max uy dy)

toRect :: Rect -> SDL.Rect
toRect (normalize -> Rect (lx,uy) (rx,dy)) = SDL.Rect (round lx) (round uy) (round (rx - lx)) (round (dy - uy))

getColor :: Surface -> Color -> IO Pixel
getColor s c = 
     let fmt = surfaceGetPixelFormat s in
     mapRGB fmt (con r) (con g) (con b)
  where con d = round ( (d c) * 255.0)



draw :: Surface -> [Box] -> IO ()
draw s [] = return ()
draw s ((Box r c):t) =
  do p <- getColor s c
     fillRect s (Just $ toRect r) p
     draw s t
     
drawBoxes s l = 
  do  p <- getColor s (Color 0 0 0)
      fillRect s (Just $ SDL.Rect 0 0 1200 1000) p
      draw s (reverse l)
      SDL.flip s
