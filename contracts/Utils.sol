// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/SignedMath.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

library Utils {

    function diagDist(int x1, int x2, int y1, int y2) internal pure returns (uint){
        uint abscissa = SignedMath.abs(x1 - x2);
        uint ordinates = SignedMath.abs(y1 - y2);
        uint quadratic = abscissa**2 + ordinates**2;
        return Math.sqrt(quadratic);
    }
}