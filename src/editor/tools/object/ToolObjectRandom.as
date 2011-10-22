package editor.tools.object
{
	import editor.Layer;
	import editor.tools.*;
	import editor.GameObject;
	import editor.ObjectLayer;
	import editor.ui.Ghost;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import editor.ui.EnterTextInt;
	
	
	public class ToolObjectRandom extends ObjectTool
	{
		private var ghost:Ghost;
		
		public function ToolObjectRandom( layer:Layer )
		{
			super( layer );
		}
		
		override protected function activate( e:Event ):void
		{
			super.activate(e);
			layer.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			layer.addEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
			layer.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			layer.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
		}
		
		override protected function deactivate(e:Event):void 
		{
			super.deactivate(e);
			layer.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			layer.removeEventListener( MouseEvent.RIGHT_CLICK, onRightClick );
			layer.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			layer.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
		}
		
		private function setGhost( ax:int, ay:int ):void
		{
			if (!ghost)
				addChild( ghost = new Ghost( Ogmo.level.selObject ) );
					
			ghost.x = ax;
			ghost.y = ay;
		}
		
		private function killGhost():void
		{
			if (ghost)
			{
				removeChild( ghost );
				ghost = null;
			}
		}
		
		private function onMouseDown( e:MouseEvent ):void
		{
			
			/*
			 * Place an Object anywhere there is a blank tile.
			 * 
			 * */
			if (Ogmo.gridLevel.length == 0) {
				Ogmo.showMessage("No grid created", 2500, true);
			}
			else {
				objectLayer.deselectAll();
				
				if (Ogmo.level.selObject)
				{				
					var ax:int = Math.random() * (Ogmo.widthInTiles);
					var ay:int = Math.random() * (Ogmo.heightInTiles);
					while (Ogmo.gridLevel[ay][ax]) {
						ax = Math.random() * (Ogmo.widthInTiles);
						ay = Math.random() * (Ogmo.heightInTiles);
					}
									
					//Check that it's within bounds
					if (ax < 0 || ay < 0 || ax > Ogmo.level.levelWidth - (Ogmo.level.selObject.width - Ogmo.level.selObject.originX) || ay > Ogmo.level.levelHeight - (Ogmo.level.selObject.height - Ogmo.level.selObject.originY))
						return;
					
					//Add the object
					var o:GameObject;
					o = objectLayer.addObject( Ogmo.level.selObject, ax*Ogmo.gridSize, ay*Ogmo.gridSize );
					objectLayer.selectObject( o );
				}
			}
			
			
			
			
			
			
		}
		
		private function onRightClick( e:MouseEvent ):void
		{
			/*
			 * Place an object according to the values in the GenInfo Window.
			 * 
			 * */
			
			var _numberOfObjDisp:DisplayObject = Ogmo.windows.windowObjectGenInfo.ui.getChildAt(1) ;
			var _numberOfObj:uint = (_numberOfObjDisp as EnterTextInt).value;
			
			var _topDisp:DisplayObject = Ogmo.windows.windowObjectGenInfo.ui.getChildAt(3) ;
			var _top:uint = (_topDisp as EnterTextInt).value;
			var _rightDisp:DisplayObject = Ogmo.windows.windowObjectGenInfo.ui.getChildAt(5) ;
			var _right:uint = (_rightDisp as EnterTextInt).value;			
			var _bottomDisp:DisplayObject = Ogmo.windows.windowObjectGenInfo.ui.getChildAt(7) ;
			var _bottom:uint = (_bottomDisp as EnterTextInt).value;			
			var _leftDisp:DisplayObject = Ogmo.windows.windowObjectGenInfo.ui.getChildAt(9) ;
			var _left:uint = (_leftDisp as EnterTextInt).value;		
			
			
			
			if (Ogmo.gridLevel.length == 0) {
				Ogmo.showMessage("No grid created", 2500, true);
			}
			else {
				objectLayer.deselectAll();
				
				if (Ogmo.level.selObject)
				{			
					for (var i:int = 0 ;  i < _numberOfObj; i++){
						var ax:int = Math.random() * (Ogmo.widthInTiles);
						var ay:int = Math.random() * (Ogmo.heightInTiles);
						if (ax >= Ogmo.widthInTiles-1) {
							ax -= 1;
						}
						if (ay >= Ogmo.widthInTiles-1) {
							ay -= 1;
						}
						if (ax <=0) {
							ax =1;
						}
						if (ay <= 0) {
							ay =1;
						}						

						var top:int = new int;
						var right:int = new int;
						var bottom:int = new int;
						var left:int = new int;
						var none:int = new int;
						none = 0;

						if (_top) top = Ogmo.gridLevel[ay + 1][ax];
						else top = 0;
						if (_right) right = Ogmo.gridLevel[ay][ax-1];
						else right = 0;						
						if (_bottom) bottom = Ogmo.gridLevel[ay-1][ax];
						else bottom = 0;						
						if (_left) left = Ogmo.gridLevel[ay][ax+1];
						else left = 0;
						
						if (!_top && !_right && !_bottom && !_left ) {
							top = right = bottom = left = 1;
						}
						
							
						//search for a platform to stand on top
						while (Ogmo.gridLevel[ay][ax] || (!top && !right && !bottom && !left ) ) {
							ax = Math.random() * (Ogmo.widthInTiles);
							ay = Math.random() * (Ogmo.heightInTiles);
							
							if (ax >= Ogmo.widthInTiles-1) {
								ax -= 1;
							}
							if (ay >= Ogmo.widthInTiles-1) {
								ay -= 1;
							}
							if (ax <=0) {
								ax =1;
							}
							if (ay <= 0) {
								ay =1;
							}
						
							if (_top) top = Ogmo.gridLevel[ay + 1][ax];
							else top = 0;
							if (_right) right = Ogmo.gridLevel[ay][ax+1];
							else right = 0;						
							if (_bottom) bottom = Ogmo.gridLevel[ay-1][ax];
							else bottom = 0;						
							if (_left) left = Ogmo.gridLevel[ay][ax-1];
							else left = 0;
													
							if (!_top && !_right && !_bottom && !_left ) {
								top = right = bottom = left = 1;
							}
							
						}

						//Check that it's within bounds
						if (ax < 0 || ay < 0 || ax > Ogmo.level.levelWidth - (Ogmo.level.selObject.width - Ogmo.level.selObject.originX) || ay > Ogmo.level.levelHeight - (Ogmo.level.selObject.height - Ogmo.level.selObject.originY))
							return;
						
						//Add the object
						var o:GameObject;
						o = objectLayer.addObject( Ogmo.level.selObject, ax*Ogmo.gridSize, ay*Ogmo.gridSize );
						objectLayer.selectObject( o );
					}
				}
			}
		}
		
		private function onMouseMove( e:MouseEvent ):void
		{
			if (!Ogmo.level.selObject)
			{
				killGhost();
				return;
			}
			
			var p:Point = getMouseCoords( e );
			var ax:int = p.x - Ogmo.level.selObject.originX;
			var ay:int = p.y - Ogmo.level.selObject.originY;
			
			if (ax < 0 || ay < 0 || ax > Ogmo.level.levelWidth - Ogmo.level.selObject.width || ay > Ogmo.level.levelHeight - Ogmo.level.selObject.height)
				killGhost();
			else
				setGhost( ax, ay );
		}
		
		private function onMouseOut( e:MouseEvent ):void
		{
			killGhost();
		}
		
	}

}