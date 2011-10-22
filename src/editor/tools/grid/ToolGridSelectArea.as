package editor.tools.grid 
{
	import editor.Layer;
	import editor.Utils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	
	public class ToolGridSelectArea extends GridTool
	{
		private const C_SELECT:uint 	= 0xFFFF00;
		private const C_SELECTION:uint	= 0x00FFFF;
		
		private var selectParent:Sprite;
		private var selectDraw:Sprite;
		private var selection:Bitmap;
		private var selectionRect:Rectangle;
		private var moving:Boolean = false;
		private var selecting:Boolean = false;
		private var startAt:Point = new Point;
		private var endAt:Point = new Point;
		private var moveFrom:Point = new Point;
		
		public function ToolGridSelectArea(layer:Layer) 
		{
			super(layer);
			
			addChild(selectParent = new Sprite);
			selectParent.addChild(selectDraw = new Sprite);
			selectParent.addChild(selection = new Bitmap);
			selectParent.visible = false;
			selectParent.alpha = 0.5;
			selectParent.scaleX = selectParent.scaleY = layer.gridSize;
		}
		
		override protected function activate(e:Event):void 
		{
			super.activate(e);
			layer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			layer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		override protected function deactivate(e:Event):void 
		{
			super.deactivate(e);
			layer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			layer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			Ogmo.point.x = e.stageX;
			Ogmo.point.y = e.stageY;
			Ogmo.point = globalToLocal(Ogmo.point);
			
			if (insideSelection(Ogmo.point))
			{
				
			}
			else if (Ogmo.point.x >= 0 && Ogmo.point.x < Ogmo.level.levelWidth 
					&& Ogmo.point.y >= 0 && Ogmo.point.y < Ogmo.level.levelHeight)
			{
				graphics.clear();
				selectionRect = null;
				Ogmo.windows.mouse = false;
				selecting = true;
				startAt.x = Math.floor(Ogmo.point.x / layer.gridSize);
				startAt.y = Math.floor(Ogmo.point.y / layer.gridSize);
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			endAt.x = layer.convertX(e.localX) / layer.gridSize;
			endAt.y = layer.convertY(e.localY) / layer.gridSize;
			if (selecting)
			{
				selecting = false;
				Utils.setRectForFill(Ogmo.rect, startAt.x, startAt.y, endAt.x, endAt.y, 1);
				selectionRect = Ogmo.rect;
				Ogmo.windows.mouse = true;
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var ax:int = Math.floor(e.localX / layer.gridSize) * layer.gridSize;
			var ay:int = Math.floor(e.localY / layer.gridSize) * layer.gridSize;
			if (selecting)
			{
				Utils.setRectForFill(Ogmo.rect, startAt.x * layer.gridSize , startAt.y * layer.gridSize, ax, ay, gridLayer.gridSize);
				graphics.clear();
				graphics.beginFill(C_SELECT, 0.4);
				graphics.drawRect(Ogmo.rect.x, Ogmo.rect.y, Ogmo.rect.width, Ogmo.rect.height);
				graphics.endFill();
			}
			else if (moving) 
			{

			}
		}
		
		/* Returns whether the clicked position is within the selection rectangle. */
		private function insideSelection(point:Point):Boolean
		{
			var pt:Point = point.clone();
			pt.x = Math.floor(pt.x / layer.gridSize);
			pt.y = Math.floor(pt.y / layer.gridSize);
			return (selectionRect != null && selectionRect.containsPoint(pt));
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.ctrlKey && selectionRect != null)
			{
				// Copy
				if (e.keyCode == 67)
				{
					gridLayer.storeUndo();
					Ogmo.point.x = Ogmo.point.y = 0;
					selection.bitmapData = new BitmapData(selectionRect.width, selectionRect.height);
					selection.bitmapData.copyPixels(gridLayer.grid.bitmapData, selectionRect, Ogmo.point);	
				}
				// Cut
				else if (e.keyCode == 88) 
				{
					gridLayer.storeUndo();
					Ogmo.point.x = Ogmo.point.y = 0;
					selection.bitmapData = new BitmapData(selectionRect.width, selectionRect.height);
					selection.bitmapData.copyPixels(gridLayer.grid.bitmapData, selectionRect, Ogmo.point);	
					gridLayer.grid.setCellsRect(selectionRect.x,
												selectionRect.y,
												selectionRect.width,
												selectionRect.height, false);
				}
				// Paste
				else if (e.keyCode == 86)
				{
					Ogmo.point.x = selectionRect.x;
					Ogmo.point.y = selectionRect.y;
					gridLayer.storeUndo();
					gridLayer.grid.bitmapData.copyPixels(selection.bitmapData, selection.bitmapData.rect, Ogmo.point,
						null, null, true);
				}
			}
		}
	}

}