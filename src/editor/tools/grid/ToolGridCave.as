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
	import editor.tools.grid.FlxCaveGenerator;
	
	
	public class ToolGridCave extends GridTool
	{
		private var placing:Boolean;
		private var drawMode:Boolean;
		private var rightMouseDown:Boolean;
		
		public function ToolGridCave(layer:Layer) 
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
		
		//smooth current level with Cave styling smoothing.
		
		private function onMouseDown(e:MouseEvent):void
		{
			Ogmo.windows.mouse = false;
			gridLayer.storeUndo();
			
			placing = true;
			drawMode = true;
			
			if (gridLayer.width % gridLayer.gridSize != 0 ||  gridLayer.height % gridLayer.gridSize != 0  ) {
				Ogmo.showMessage("Grid size does not divide by Level size evenly", 2000, false);
				
			}
			else {
			
				var cave:FlxCaveGenerator = new FlxCaveGenerator(gridLayer.width / gridLayer.gridSize, gridLayer.height / gridLayer.gridSize);
				
				// get current level
				var currentLevel:Array = new Array();
				currentLevel = super.getCurrentLevel();
				
				// Refine level based on smoothing iterations
				var caveMatrix:Array = cave.refineCurrentLevel(currentLevel);
				
				for (var i:int = 0; i < gridLayer.width / gridLayer.gridSize; i++) {
					for (var j:int = 0; j < gridLayer.height / gridLayer.gridSize; j++) {
						gridLayer.grid.setCell(i, j, caveMatrix[j][i]);
					}
				}
				Ogmo.gridLevel = caveMatrix;
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
			
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			Ogmo.windows.mouse = true;
			
			if (drawMode)
				placing = false;
		}
		
		
		//create brand new cave level.
		
		private function onRightMouseDown(e:MouseEvent):void
		{
			rightMouseDown = true;
			Ogmo.windows.mouse = false;
			gridLayer.storeUndo();
			
			placing = true;
			drawMode = false;
			
			if (gridLayer.width % gridLayer.gridSize != 0 ||  gridLayer.height % gridLayer.gridSize != 0  ) {
				Ogmo.showMessage("Grid size does not divide by Level size evenly", 2000, false);
				
			}
			else {
				// Create cave of size 200x100 tiles
				var cave:FlxCaveGenerator = new FlxCaveGenerator(gridLayer.width / gridLayer.gridSize, gridLayer.height / gridLayer.gridSize);

				// Generate the level and returns a matrix
				// 0 = empty, 1 = wall tile
				var caveMatrix:Array = cave.generateCaveLevel();

				for (var i:int = 0; i < gridLayer.width / gridLayer.gridSize; i++) {
					for (var j:int = 0; j < gridLayer.height / gridLayer.gridSize; j++) {
						gridLayer.grid.setCell(i, j, caveMatrix[j][i]);
					}
				}
				
				Ogmo.gridLevel = caveMatrix;
							
				// get current level
				var currentLevel:Array = new Array();
				for ( var y:uint = 0; y < gridLayer.width / gridLayer.gridSize; ++y )
				{
					currentLevel.push( new Array );
					for ( var x:uint = 0; x < gridLayer.height / gridLayer.gridSize; ++x ) {
						if (gridLayer.grid.getCell(x, y))
							currentLevel[y].push(1);
						else if (!gridLayer.grid.getCell(x, y))
							currentLevel[y].push(0);
					}
				}	
			}
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
			{
					
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Ogmo.keycode_ctrl)
				layer.setTool(new ToolGridFill(layer), new QuickTool(ToolGridPencil, QuickTool.CTRL));
		}
		
	}

}