(module
	;; each board position can be either black or white and be crowned or not
	(global $BLACK i32 (i32.const 1)) ;; 0001
	(global $WHITE i32 (i32.const 2)) ;; 0010
	(global $CMASK i32 (i32.const 4)) ;; 0011
	(global $CROWN i32 (i32.const 4)) ;; 0100
	;; using linear memory to represent two dimensional array that is the game board
	(memory $mem 1)
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

	(export "offsetPosition" (func $offsetPosition))
	(export "isBlack" (func $isBlack))
	(export "isWhite" (func $isWhite))
	(export "isCrowned" (func $isCrowned))
	(export "addCrown" (func $addCrown))
	(export "removeCrown" (func $removeCrown))
)
