(module
	;; each board position can be either black or white and be crowned or not
	(global $BLACK i32 (i32.const 1)) ;; 0001
	(global $WHITE i32 (i32.const 2)) ;; 0010
	(global $CMASK i32 (i32.const 4)) ;; 0011
	(global $CROWN i32 (i32.const 4)) ;; 0100
	;; using linear memory to represent two dimensional array that is the game board
	(memory $mem 1)
	;; turns will be 1 and 2 for black and white
	(global $currentTurn (mut i32) (i32.const 0))
	(func $indexForPosition (param $x i32) (param $y i32) (result i32)
		(i32.add
			(i32.mul 
				(i32.const 8)
				(get_local $y)
			)
			(get_local $x)
		)
	)
	;; offset = (x + y * 8) * 4
	(func $offsetPosition (param $x i32) (param $y i32) (result i32)
		(i32.mul
			(call $indexForPosition (get_local $x) (get_local $y))
			(i32.const 4)
		)
	)
	;; query a position - black, white, crowned
	(func $isBlack (param $piece i32) (result i32)
		(i32.eq
			(i32.and (get_global $BLACK) (get_local $piece) )
			(get_global $BLACK)
		)
	)
	(func $isWhite (param $piece i32) (result i32)
		(i32.eq
			(i32.and (get_global $WHITE) (get_local $piece))
			(get_global $WHITE)
		)
	)
	(func $isCrowned (param $piece i32) (result i32)
		(i32.eq
			(i32.and (get_global $CROWN) (get_local $piece) )
			(get_global $CROWN)
		)
	)
	;; add crown
	(func $addCrown (param $piece i32) (result i32)
		(i32.or
			(get_global $CROWN)
			(get_local $piece)
		)
	)
	;; remove crown
	(func $removeCrown (param $piece i32) (result i32)
		(i32.and
			(get_global $CMASK)
			(get_local $piece)
		)
	)
	;; set a piece on the board
	(func $setPiece (param $piece i32) (param $x i32) (param $y i32)
		(i32.store
			(call $offsetPosition (get_local $x) (get_local $y))
			(get_local $piece)
		)
	)
	;; get piece from the board
	(func $getPiece (param $x i32) (param $y i32) (result i32)
		(if (result i32) 
			(block (result i32)
				(call $inRange (get_local $x) (get_local $y))
			)
			(then
				(i32.load
					(call $offsetPosition (get_local $x) (get_local $y))
				)
			)
			(else
				(unreachable)
			)
		)
	)
	;; check if the given coordinates are within the board
	(func $inRange (param $x i32) (param $y i32) (result i32)
		(i32.and
			(i32.and (i32.ge_s (get_local $x) (i32.const 0)) (i32.le_s (get_local $x) (i32.const 7)) )
			(i32.and (i32.ge_s (get_local $y) (i32.const 0)) (i32.le_s (get_local $y) (i32.const 7)) )
		)
	)
	;; get current turn
	(func $getTurn (result i32)
		(get_global $currentTurn)
	)
	;; switch turn
	(func $toggleTurn 
		(if (i32.eq (call $getTurn) (i32.const 1))
		(then (call $setTurn (i32.const 2)))
		(else (call $setTurn (i32.const 1)))
		)
	)
	;; set turn
	(func $setTurn (param $t i32)
		(set_global $currentTurn (get_local $t))
	)
	;; determine if it's the players turn
	(func $isPlayerTurn (param $player i32) (result i32)
		(i32.gt_s
			(i32.and (get_local $player) (call $getTurn))
			(i32.const 0)
		)
	)

	(export "offsetPosition" (func $offsetPosition))
	(export "isBlack" (func $isBlack))
	(export "isWhite" (func $isWhite))
	(export "isCrowned" (func $isCrowned))
	(export "addCrown" (func $addCrown))
	(export "removeCrown" (func $removeCrown))
)
