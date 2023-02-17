pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    uint256 public constant tokensPerEth = 100;
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        require(msg.value > 0, "ERROR: Use some ether");

        uint256 _amountofTokens = msg.value * tokensPerEth;

        yourToken.transfer(msg.sender, _amountofTokens);
        emit BuyTokens(msg.sender, msg.value, _amountofTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        uint256 contractOwner = address(this).balance;

        //require(msg.sender == owner, "Only owner can withdraw the money.");
        // (bool callSuccess, ) = payable(msg.sender).call{
        //     value: contractOwner
        // }("");
        payable(msg.sender).transfer(contractOwner);
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) external {
        uint256 payingAmount = _amount / tokensPerEth;
        require(address(this).balance >= payingAmount, "Not enough ETH!");
        yourToken.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(payingAmount);
        emit SellTokens(msg.sender, payingAmount, _amount);
    }
}
