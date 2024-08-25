// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ParticipationToken is ERC20 {
    using SafeMath for uint256;

    address public teacher;
    uint256 public constant CAP = 2.5 * 10**18; // Cap of 2.5 tokens

    event TokensRewarded(address indexed student, uint256 amount);
    event TokensBurned(address indexed student, uint256 amount);
    event OwnershipTransferred(address indexed previousTeacher, address indexed newTeacher);

    constructor() ERC20("ParticipationToken", "PTK") {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only the teacher can perform this action");
        _;
    }

    function rewardTokens(address student, uint256 amount) public onlyTeacher {
        require(student != address(0), "Invalid student address");
        require(totalSupply().add(amount) <= CAP, "Cap exceeded");

        _mint(student, amount);
        emit TokensRewarded(student, amount);
    }

    function burnTokens(address student, uint256 amount) public onlyTeacher {
        require(student != address(0), "Invalid student address");
        _burn(student, amount);
        emit TokensBurned(student, amount);
    }

    function transferOwnership(address newTeacher) public onlyTeacher {
        require(newTeacher != address(0), "Invalid address for new teacher");
        emit OwnershipTransferred(teacher, newTeacher);
        teacher = newTeacher;
    }
}
