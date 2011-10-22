package editor.tools.grid 
{
	import editor.GridLayer;
	import editor.Layer;
	import editor.tools.QuickTool;
	import editor.ui.EnterText;
	import editor.ui.EnterTextInt;
	import editor.ui.ValueModifier;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	
	public class ToolGridRandom extends GridTool
	{
		private var placing:Boolean;
		private var drawMode:Boolean;
		private var rightMouseDown:Boolean;
		
		public function ToolGridRandom(layer:Layer) 
		{
			super(layer);
			
			placing = false;
			
			Ogmo.widthInTiles = gridLayer.width / gridLayer.gridSize;
			Ogmo.heightInTiles = gridLayer.height / gridLayer.gridSize;
			Ogmo.gridSize = gridLayer.gridSize;
		}
		
		override protected function activate(e:Event):void
		{
			super.activate(e);
			layer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			layer.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
			layer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		override protected function deactivate(e:Event):void 
		{
			super.deactivate(e);
			layer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			layer.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
			stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
			layer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			Ogmo.windows.mouse = false;
			gridLayer.storeUndo();
			
			placing = true;
			drawMode = true;
			
			//Do you want to create walls, floor, roof, etc.
			var _walls:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(11) ;
			if ((_walls as EnterTextInt).value == 1){
				this.createWalls(true);
			}
			
			
			
			var _area:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(13) ;
			if ((_area as EnterTextInt).value == 1) {
				var rx:uint = (gridLayer.width / gridLayer.gridSize) /4 ;
				var ry:uint = (gridLayer.height / gridLayer.gridSize) / 4;
				
				this.buildRoom(rx*0,ry*0,true);
				this.buildRoom(rx*1,ry*0,true);
				this.buildRoom(rx*2,ry*0,true);
				this.buildRoom(rx*3,ry*0,true);
				this.buildRoom(rx*0,ry*1,true);
				this.buildRoom(rx*1,ry*1,true);
				this.buildRoom(rx*2,ry*1,true);
				this.buildRoom(rx*3,ry*1,true);
				this.buildRoom(rx*0,ry*2,true);
				this.buildRoom(rx*1,ry*2,true);
				this.buildRoom(rx*2,ry*2,true);
				this.buildRoom(rx*3,ry*2,true);
				this.buildRoom(rx*0,ry*3,true);
				this.buildRoom(rx*1,ry*3,true);
				this.buildRoom(rx*2,ry*3,true);
				this.buildRoom(rx*3,ry*3,true);
			}
			
			else {
				this.buildRoom(Math.floor(e.localX / gridLayer.gridSize) - (gridLayer.width / gridLayer.gridSize) / 8,Math.floor(e.localY / gridLayer.gridSize)  - (gridLayer.height / gridLayer.gridSize) / 8,true);
			}
			
			Ogmo.gridLevel = super.getCurrentLevel();
			
			
			
		}
		
		protected function buildRoom(RX:uint,RY:uint, draw:Boolean):void
		{
			
			var _num:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(1) ;
			var _minW:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(3) ;
			var _maxW:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(5) ;
			var _minH:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(7) ;
			var _maxH:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(9) ;
			
			var rw:uint = (gridLayer.width / gridLayer.gridSize) /4;
			var ry:uint = (gridLayer.height / gridLayer.gridSize) / 4;
			
			var sx:uint;
			var sy:uint;
			
			//trace((_num as EnterTextInt).value, (_minW as EnterTextInt).value, (_maxW as EnterTextInt).value, (_minH as EnterTextInt).value, (_maxH as EnterTextInt).value);
			
			//then place a bunch of blocks
			var numBlocks:uint = (_num as EnterTextInt).value;
			var maxW:uint = (_maxW as EnterTextInt).value;
			var minW:uint = (_minW as EnterTextInt).value;
			var maxH:uint = (_maxH as EnterTextInt).value;
			var minH:uint = (_minH as EnterTextInt).value;
			var bx:uint;
			var by:uint;
			var bw:uint;
			var bh:uint;
			var check:Boolean;
			for(var i:uint = 0; i < numBlocks; i++)
			{
				do
				{
					//keep generating different specs if they overlap the spawner
					bw = minW + Math.random()*(maxW-minW);
					bh = minH + Math.random()*(maxH-minH);
					bx = -1 + Math.random()*(rw+1-bw);
					by = -1 + Math.random()*(ry+1-bh);
					check = true;
					
				} while(!check);
				
				gridLayer.grid.setCellsRect( RX + bx , RY + by , bw , bh   , draw);
				
			}
		}
		
		private function createWalls(draw:Boolean):void 
		{
			// draw walls
			
			gridLayer.grid.setCellsRect(0,0,1,gridLayer.height / gridLayer.gridSize,draw);
			gridLayer.grid.setCellsRect(gridLayer.width/gridLayer.gridSize - 1, 0 ,1,gridLayer.height / gridLayer.gridSize,draw);
			
			// draw ceiling and floor
			
			gridLayer.grid.setCellsRect(0,0,gridLayer.width/gridLayer.gridSize,1 ,draw);
			gridLayer.grid.setCellsRect(0,gridLayer.height/gridLayer.gridSize-1,gridLayer.width/gridLayer.gridSize,1 ,draw);
			
			/*			
			
			// draw walls
			for (var i:int = 0; i < gridLayer.height / gridLayer.gridSize; i++ ){
				gridLayer.grid.setCell(0, i, true);
				gridLayer.grid.setCell(gridLayer.width/gridLayer.gridSize - 1, i, true);
			}
			
			// draw ceiling and floor
			for (i = 0; i < gridLayer.width / gridLayer.gridSize; i++ ){
				gridLayer.grid.setCell(i, 0, true);
				gridLayer.grid.setCell(i, gridLayer.height/gridLayer.gridSize - 1, true);
			}
			*/
			
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			Ogmo.windows.mouse = true;
			
			if (drawMode)
				placing = false;
		}
		
		private function onRightMouseDown(e:MouseEvent):void
		{
			rightMouseDown = true;
			Ogmo.windows.mouse = false;
			gridLayer.storeUndo();
			
			placing = true;
			drawMode = false;
			//Do you want to create walls, floor, roof, etc.
			var _walls:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(11) ;
			if ((_walls as EnterTextInt).value == 1){
				this.createWalls(false);
			}
			
			var _area:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(13) ;
			if ((_area as EnterTextInt).value == 1) {
				var rx:uint = (gridLayer.width / gridLayer.gridSize) /4 ;
				var ry:uint = (gridLayer.height / gridLayer.gridSize) / 4;
				
				this.buildRoom(rx*0,ry*0,false);
				this.buildRoom(rx*1,ry*0,false);
				this.buildRoom(rx*2,ry*0,false);
				this.buildRoom(rx*3,ry*0,false);
				this.buildRoom(rx*0,ry*1,false);
				this.buildRoom(rx*1,ry*1,false);
				this.buildRoom(rx*2,ry*1,false);
				this.buildRoom(rx*3,ry*1,false);
				this.buildRoom(rx*0,ry*2,false);
				this.buildRoom(rx*1,ry*2,false);
				this.buildRoom(rx*2,ry*2,false);
				this.buildRoom(rx*3,ry*2,false);
				this.buildRoom(rx*0,ry*3,false);
				this.buildRoom(rx*1,ry*3,false);
				this.buildRoom(rx*2,ry*3,false);
				this.buildRoom(rx*3,ry*3,false);
			}
			
			else {
				this.buildRoom(Math.floor(e.localX / gridLayer.gridSize) - (gridLayer.width / gridLayer.gridSize) / 8,Math.floor(e.localY / gridLayer.gridSize)  - (gridLayer.height / gridLayer.gridSize) / 8, false);
			}
			
			Ogmo.gridLevel = super.getCurrentLevel();
		}
		
		private function onRightMouseUp(e:MouseEvent):void
		{
			rightMouseDown = false;
			Ogmo.windows.mouse = true;
			
			if (!drawMode)
				placing = false;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			var _area:DisplayObject = Ogmo.windows.windowGridInfo.ui.getChildAt(13) ;
			var ax:int = Math.floor(e.localX / gridLayer.gridSize);
			var ay:int = Math.floor(e.localY / gridLayer.gridSize);
			if (placing && ax >= 0 && ax < gridLayer.grid.width && ay >= 0 && ay < gridLayer.grid.height && (_area as EnterTextInt).value == 0 && !rightMouseDown) 
				this.buildRoom(Math.floor(e.localX / gridLayer.gridSize) - (gridLayer.width / gridLayer.gridSize) / 8,Math.floor(e.localY / gridLayer.gridSize)  - (gridLayer.height / gridLayer.gridSize) / 8,true);
			if (placing && ax >= 0 && ax < gridLayer.grid.width && ay >= 0 && ay < gridLayer.grid.height && (_area as EnterTextInt).value == 0 && rightMouseDown) 
				this.buildRoom(Math.floor(e.localX / gridLayer.gridSize) - (gridLayer.width / gridLayer.gridSize) / 8,Math.floor(e.localY / gridLayer.gridSize)  - (gridLayer.height / gridLayer.gridSize) / 8,false);
				
				
			Ogmo.gridLevel = super.getCurrentLevel();
			
				
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Ogmo.keycode_ctrl)
				layer.setTool(new ToolGridFill(layer), new QuickTool(ToolGridPencil, QuickTool.CTRL));
		}
		
	}

}