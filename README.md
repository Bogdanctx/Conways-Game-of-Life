<h1><b>Introduction</b></h1>
The <b><i>Game of Life</b></i>, also known simply as <b><i>Life</b></i>, is a cellular automaton devised by the British mathematician <b>John Horton Conway</b> in <b>1970</b>. It is a <b>zero-player game</b>, meaning that its evolution is determined by its initial state, requiring no further input. (<a href="https://en.wikipedia.org/wiki/Conway's_Game_of_Life">Wikipedia</a>)

The state of a system is described by the cumulative state of its component cells, and the following rules govern them:

1. <b>Underpopulation</b>: Each cell (alive in the current generation) with fewer than two neighbors alive dies in the next generation.
2. <b>Live Cell Continuity</b>: Each cell (alive in the current generation) with two or three neighbors alive will survive to the next generation
3. <b>Overpopulation</b>: Each cell (alive in the current generation) with more than three neighbors alive dies in the next generation.
4. <b>Creation</b>: A dead cell with exactly three neighbors alive will come to life in the next generation.
5. <b>Dead Cell Continuity</b>: Any other dead cell that doesn't meet the creation rule remains dead.

The neighbors of a cell are considered to be the eight surrounding cells in a two-dimensional matrix:
    <table align="center">
        <tr>
            <td>a00</td>
            <td>a01</td>
            <td>a02</td>
        </tr>
        <tr>
            <td>a10</td>
            <td>cell</td>
            <td>a12</td>
        </tr>
        <tr>
            <td>a20</td>
            <td>a21</td>
            <td>a22</td>
        </tr>
    </table>
<strong><p>For cells located on the first row, first column, last row, and last column, extension to 8 neighbors is considered. This extension includes cells that are not within the matrix, treating them as dead cells. Let <sup>+</sup>S be the extended matrix.</p></strong>

<p>Consider below the initial configuration of a system. Let it be <b>S<sub>0</sub></b>:</p>
<table>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
  </tr>
</table>

<p>Also consider below the extended matrix <b><sup>+</sup>S<sub>0</sub></b></p>
<table>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
</table>


We define the state of a system at generation n as a matrix S<sub>n</sub> ∈ M<sub>m×n</sub>({0, 1}) (where m is the number of rows and n is the number of columns), where 0 represents a dead cell, and 1 represents a live cell (in the current generation).
A k-evolution (k ≥ 0) of the system is an iteration S<sub>0</sub> → S<sub>1</sub> → · · · → S<sub>k</sub>, where each S<sub>i+1</sub> is obtained from S<sub>i</sub> by applying the five rules mentioned above.

<h1><b>Symmetric Encryption Schema</b></h1>
<p>We define an encryption key (starting from an initial configuration S<sub>0</sub> and a k-evolution) as the operation <code>&lt; S<sub>0</sub>, k &gt;</code>. This represents the one-dimensional array of data (understood as a bit string) obtained by concatenating the lines of <b><sup>+</sup>S<sub>k</sub></sub></b>.</p>

Using previous declared system configuration, for <b><code>&lt; S<sub>0</sub>, 1 &gt;</code></b> will result in: <b>0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0</b> = <b><sup>+</sup>S<sub>1</sub></b>

<p>Consider the message <i>m</i> as a plaintext (a string of characters without spaces). The encryption {m}<sub><code>&lt; S<sub>0</sub>, k &gt;</code></sub> involves XOR-ing the plaintext message <i>m</i> with the result obtained from <code>&lt; S<sub>0</sub>, k &gt;</code>. The following cases apply:</p>

<ul>
  <li>If the message and the key have the same length, XOR each element one by one until the result is obtained.</li>
  <li>If the message is shorter than the key, use only the first part of the key corresponding to the length of the message.</li>
  <li>If the message is longer than the key, replicate the key as many times as necessary to encrypt the entire message.</li>
</ul>

<h1>Encryption</h1>
<p>Consider <i>m=text</i> and use <b><sup>+</sup>S<sub>1</sub></b> as the key, where <b>S<sub>0</sub></b> is the initial configuration described earlier. We have seen that the obtained result is the bit string: <b>0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0</b>. To do the encryption <i>m</i> must be transformed also in a bit string: <b>0 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 1 1 0 0 0 0 1 1 1 0 1 0 0</b></p>
<p>Since bit string length of <b><sup>+</sup>S<sub>1</sub></b> is less than the bit string of the message <i>m</i>, the first 2 bits of <b><sup>+</sup>S<sub>1</sub></b> must be concatenated at the end of the string:</p>

<b>0 0</b> 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0+<b>0 0</b>. Let this string be <b>A</b>
<br>
0 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 1 1 0 0 0 0 1 1 1 0 1 0 0 = m

<p>Now since the lengths are all equal, the encryption can be done:</p>

<table>
  <tr>
    <td>A</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td><i>m</i></td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>R=(A^m)</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>1</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>0</td>
    <td>0</td>
  </tr>
</table>

  
<p>The result R is transformed in a string with hexadecimal characters taking every 4-bit sequence: <b>0x74E5F874</b></p>

<h1>Decryption</h1>
<p>For decryption are applied the same rules as for encryption, because m ^ <b><code>&lt; S<sub>0</sub>, 1 &gt;</code></b> ^ <b><code>&lt; S<sub>0</sub>, 1 &gt;</code></b> = m</p>

<h1>Input</h1>
<p>Below is an example of how an input should look like</p>
<table>
  <tr>
    <td>3 // lines</td>
  </tr>
  <tr>
    <td>4 // columns</td>
  </tr>
  <tr>
    <td>5 // number of alive cells</td>
  </tr>
  <tr>
    <td>0 // x<sub>1</sub></td>
  </tr>
  <tr>
    <td>1 // y<sub>1</sub></td>
  </tr>
  <tr>
    <td>0 // x<sub>2</sub></td>
  </tr>
  <tr>
    <td>2 // y<sub>2</sub></td>
  </tr>
  <tr>
    <td>1 // x<sub>3</sub></td>
  </tr>
  <tr>
    <td>0 // y<sub>3</sub></td>
  </tr>
  <tr>
    <td>2 // x<sub>4</sub></td>
  </tr>
  <tr>
    <td>2 // y<sub>4</sub></td>
  </tr>
  <tr>
    <td>2 // x<sub>5</sub></td>
  </tr>
  <tr>
    <td>3 // y<sub>5</sub></td>
  </tr>
  <tr>
    <td>1 // number of evolutions</td>
  </tr>
  <tr>
    <td>0 // or 1 (0 - encryption, 1 - decryption)</td>
  </tr>
  <tr>
    <td>text // text=anything for encryption | text=0x{HEXADECIMAL CHARS} for decryption (e.g. text=0x74E5F874)</td>
  </tr>
</table>

<h1>Compilation</h1>
<p>You can compile the source using <b>gcc -m32 game_of_life.s -o game_of_life</b></p>
<p>Run the program using <b>./game_of_life</b></p>
<p>Additional: You can create a text file with an input and redirect the program to read the input from that file running the executable as following: <b>./game_of_life < whatever_file_name.txt</b></p>
<p>Yoy may expect the following warnings after compilation: <b>/usr/bin/ld: /tmp/ccNhjtjD.o: warning: relocation in read-only section `.text'</b> and <b>/usr/bin/ld: warning: creating DT_TEXTREL in a PIE</b>. You can hide these warnings adding <b>-no-pie</b> at the end of the compilation command: <b>gcc -m32 game_of_life -o game_of_life -no-pie</b></b></p>
