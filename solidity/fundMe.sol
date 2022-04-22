// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0;

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// AggregatorV3Interface rinkbey address 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e

contract FundMe{

    address payable immutable owner;
    AggregatorV3Interface private pricefeed;
    uint public minValue;
    mapping(address=>uint) myContributations;

    constructor(uint _minValue){
        owner = payable(msg.sender);
        pricefeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        minValue = _minValue;
    }

    fallback() external payable {
        require(getConversionRate(msg.value) >= minValue * 10 ** 18, "You need to spend more ETH!");
        myContributations[msg.sender] += msg.value;
    }

    function getDecimals() external view returns(uint8) {
        return pricefeed.decimals();
    }   

    function getVerion() external view returns(uint) {
        return pricefeed.version();
    } 

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
         // ETH/USD rate in 18 digit 
         return uint256(answer * 10000000000);
    }
    
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }   


}