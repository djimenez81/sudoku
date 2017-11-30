function sudoku = sudokuSolver(theGrid,theScopes)
% This function solves, or attemtps to solve a generalized sudoku grid, given
% the original grid of clues, and the corresponding scopes. A generalized sudoku
% grid is one not limited to a 9x9 structure (but nxn in general) and not
% limited to the common standard scopes.
%
% INPUT:
%   - grid: The original grid, the square matrix containing the clues, and NaN
%           values everywhere else.
%   - scopes: The scopes. In the standard version of sudoku, these would be the
%             rows, the columns and the nine boxes. For the standard version of
%             Sudoku, these would be generated by standardScopes(3);
%
% OUTPUT:
%   - sudoku: A struct containing the completed grid (if it is possible to solve
%             it to the end) as well as some other parameters.
%
% TERMINOLOGY:
% It may be overkill, but it makes sense to me to include in this file some of
% the most standard terminology.
%   - Grid: The board as a whole.
%   - Clues: Also known as givens, values that are given since the beginning.
%   - Scopes: A zone, whether a row, a column, a box, or any other region that
%            that need to be filled with exactly one of each of the digits.
%
% STRUCTURE FIELDS:
%  - sudoku.grid: The grid under which the algorithm works.
%  - sudoku.clues: The original set of clues of the sudoku.
%  - sudoku.scopes: The set of scopes.
%  - sudoku.scopeCell: Boolean matrix N^2xM, where N is the side of the grid
%        and M is the number of scopes. The column sC(:,n) is true on the
%        entries that correspond to the cells in the scope n, and the row
%        sC(k,:) contains the information of the scopes of which the cell
%        [i,j] = ind2sub([N,N],k) is part.
%  - sudoku.theFilled: A boolean NxN matrix, with a true if the corresponding
%        cell in theGrid has already been filled.
%  - sudoku.thePosib: an NxNxN boolean array. tP(i,j,k) = true if tF(i,j) is
%        false and k has not been eliminated as a possible value for the cell
%        (i,j).
%
% SO FAR:
%
% TO DO:
%   - Some validation of the data.
%
  [N,M] = size(theScopes);
  sudoku.clues    = theGrid;
  sudoku.scopes   = theScopes;
  sudoku.grid     = nan(N);
  sudoku.filled   = false(N);
  sudoku.possible = false(N,N,N);
  sudoku.fillscop = false(N,M);
  sudoku.viable   = true;
  sudoku = initScopeCell(sudoku);
  sudoku = initializeSudoku(sudoku);
end


function sudoku = initializeSudoku(sudoku)
% This function initialize the sudoku from the information that is given.
%
% INPUT:
%   - sudoku: The struct
%
% OUTPUT:
%   - sudoku: The struct initialized.
%
  [N,M]   = size(sudoku.scopes);
  initIdx = find(~isnan(sudoku.clues));
  sudoku.trash = initIdx;
  K = length(initIdx);
  k = 1;
  initFlag = true;
  while initFlag
    idx = initIdx(k);
    val = sudoku.clues(idx);
    sudoku = insertValue(sudoku,idx,val);
    k = k + 1;
    if ~sudoku.viable
      initFlag = false;
    elseif k > K
      initFlag = false;
    end
  end
end


function sudoku = initScopeCell(sudoku)
% This function creates a field in the structure to identify to which scopes is
% a cell a member of.
%
% INPUT:
%   - sudoku: The struct
%
% OUTPUT:
%   - sudoku: The struct initialized.
%
  [N,M] = size(sudoku.scopes);
  scopeCell = false(N^2,M);
  for i=1:N^2
      for j=1:M
  	    if ~isempty(find(sudoku.scopes(:,j)==i))
  		    scopeCell(i,j)=true;
  		end
  	end
  end
  sudoku.scopecell = scopeCell;
end