export class WoodokuEngine {
  constructor() {
    this.grid = Array(9).fill(null).map(() => Array(9).fill(0));
    this.score = 0;
    this.currentPieces = [];
    this.gameOver = false;
    this.pieceColors = {
      weak: '#fbbf24',      // Yellow - weak systems
      mediocre: '#f97316',  // Orange - mediocre systems  
      great: '#ef4444',     // Red - great systems
      best: '#ffffff'       // White - best systems
    };
    this.generateNewPieces();
  }

  // Define piece shapes with their strength ratings
  getPieceShapes() {
    return {
      // Weak pieces (1-2 blocks)
      single: { blocks: [[0,0]], strength: 'weak' },
      double_h: { blocks: [[0,0],[0,1]], strength: 'weak' },
      double_v: { blocks: [[0,0],[1,0]], strength: 'weak' },
      
      // Mediocre pieces (3-4 blocks)
      triple_h: { blocks: [[0,0],[0,1],[0,2]], strength: 'mediocre' },
      triple_v: { blocks: [[0,0],[1,0],[2,0]], strength: 'mediocre' },
      L_small: { blocks: [[0,0],[1,0],[1,1]], strength: 'mediocre' },
      T_small: { blocks: [[0,0],[0,1],[0,2],[1,1]], strength: 'mediocre' },
      square_2x2: { blocks: [[0,0],[0,1],[1,0],[1,1]], strength: 'mediocre' },
      
      // Great pieces (5-6 blocks)
      L_large: { blocks: [[0,0],[1,0],[2,0],[2,1],[2,2]], strength: 'great' },
      T_large: { blocks: [[0,0],[0,1],[0,2],[1,1],[2,1]], strength: 'great' },
      plus: { blocks: [[0,1],[1,0],[1,1],[1,2],[2,1]], strength: 'great' },
      zigzag: { blocks: [[0,0],[0,1],[1,1],[1,2],[2,2]], strength: 'great' },
      
      // Best pieces (7-9 blocks)
      line_5: { blocks: [[0,0],[0,1],[0,2],[0,3],[0,4]], strength: 'best' },
      square_3x3: { blocks: [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]], strength: 'best' },
      cross: { blocks: [[0,1],[1,0],[1,1],[1,2],[2,1],[0,0],[0,2],[2,0],[2,2]], strength: 'best' }
    };
  }

  generateNewPieces() {
    this.currentPieces = [];
    const shapes = this.getPieceShapes();
    const shapeKeys = Object.keys(shapes);
    
    for (let i = 0; i < 3; i++) {
      const randomKey = shapeKeys[Math.floor(Math.random() * shapeKeys.length)];
      const shape = shapes[randomKey];
      this.currentPieces.push({
        blocks: JSON.parse(JSON.stringify(shape.blocks)),
        strength: shape.strength,
        color: this.pieceColors[shape.strength],
        placed: false
      });
    }
  }

  canPlacePiece(piece, row, col) {
    for (const [dr, dc] of piece.blocks) {
      const r = row + dr;
      const c = col + dc;
      if (r < 0 || r >= 9 || c < 0 || c >= 9 || this.grid[r][c] !== 0) {
        return false;
      }
    }
    return true;
  }

  placePiece(piece, row, col) {
    if (!this.canPlacePiece(piece, row, col)) return false;
    
    for (const [dr, dc] of piece.blocks) {
      this.grid[row + dr][col + dc] = piece.color;
    }
    
    piece.placed = true;
    const linesCleared = this.checkAndClearLines();
    this.score += piece.blocks.length * 10 + linesCleared * 100;
    
    // Generate new pieces if all are placed
    if (this.currentPieces.every(p => p.placed)) {
      this.generateNewPieces();
    }
    
    // Check game over
    this.checkGameOver();
    
    return true;
  }

  checkAndClearLines() {
    let cleared = 0;
    const rowsToClear = [];
    const colsToClear = [];
    const boxesToClear = [];

    // Check rows
    for (let r = 0; r < 9; r++) {
      if (this.grid[r].every(cell => cell !== 0)) {
        rowsToClear.push(r);
      }
    }

    // Check columns
    for (let c = 0; c < 9; c++) {
      if (this.grid.every(row => row[c] !== 0)) {
        colsToClear.push(c);
      }
    }

    // Check 3x3 boxes
    for (let boxRow = 0; boxRow < 3; boxRow++) {
      for (let boxCol = 0; boxCol < 3; boxCol++) {
        let full = true;
        for (let r = boxRow * 3; r < boxRow * 3 + 3; r++) {
          for (let c = boxCol * 3; c < boxCol * 3 + 3; c++) {
            if (this.grid[r][c] === 0) {
              full = false;
              break;
            }
          }
          if (!full) break;
        }
        if (full) {
          boxesToClear.push([boxRow, boxCol]);
        }
      }
    }

    // Clear rows
    rowsToClear.forEach(r => {
      for (let c = 0; c < 9; c++) {
        this.grid[r][c] = 0;
      }
      cleared++;
    });

    // Clear columns
    colsToClear.forEach(c => {
      for (let r = 0; r < 9; r++) {
        this.grid[r][c] = 0;
      }
      cleared++;
    });

    // Clear boxes
    boxesToClear.forEach(([boxRow, boxCol]) => {
      for (let r = boxRow * 3; r < boxRow * 3 + 3; r++) {
        for (let c = boxCol * 3; c < boxCol * 3 + 3; c++) {
          this.grid[r][c] = 0;
        }
      }
      cleared++;
    });

    return cleared;
  }

  checkGameOver() {
    // Check if any piece can be placed anywhere
    for (const piece of this.currentPieces) {
      if (piece.placed) continue;
      
      for (let r = 0; r < 9; r++) {
        for (let c = 0; c < 9; c++) {
          if (this.canPlacePiece(piece, r, c)) {
            this.gameOver = false;
            return;
          }
        }
      }
    }
    
    this.gameOver = true;
  }

  reset() {
    this.grid = Array(9).fill(null).map(() => Array(9).fill(0));
    this.score = 0;
    this.gameOver = false;
    this.generateNewPieces();
  }
}
