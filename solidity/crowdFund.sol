// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <0.9.0; 

import "./IERC20.sol";

contract CrowdFund{
    
    // Events in CrowdFund
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    // State Variables
    uint public count;
    struct Campaign{
        address creator;
        uint goal;
        uint32 startAt;
        uint32 endAt;
        uint pledged;
        bool claimed;}

    // mappings of campaigns
    mapping(uint=>Campaign) public campaigns;

    // id -> user -> amount
    mapping(uint=>mapping(address=>uint)) pledgedAmount;

    // token to be pledged
    IERC20 public immutable token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal,uint32 _startAt,uint32 _endAt) external {

        require(_startAt >= block.timestamp," start time is less than current Time");
        require(_endAt >=_startAt," Invalid time frame. start > end");
        require(_endAt <=_startAt + 90 days," Time frame Exeeded..");

        campaigns[count] = Campaign({
            creator:msg.sender,
            goal:_goal,
            startAt:_startAt,
            endAt:_endAt,
            pledged:0,
            claimed:false
        });

        count += 1;
        emit Launch(count, msg.sender, _goal, _startAt, _endAt);       
    }

    // This function allows to pledge the tokens to the campaing launched.
    function pledge(uint _id,uint _amount) external {

        Campaign storage campaign = campaigns[_id];
        
        require(block.timestamp >= campaign.startAt,"Campain not yet started... ");
        require(block.timestamp < campaign.endAt,"CampainEnded... ");
        require(token.balanceOf(msg.sender) >= _amount,"Insufficients Funds...");

        // transfer funds from ERC20 token to this contract
        token.transferFrom(msg.sender, address(this), _amount);
        // Update the amount in pledgedAmount
        pledgedAmount[_id][msg.sender] += _amount;

        // updated pledged field in campaign
        campaign.pledged += _amount;

        emit Pledge(_id, msg.sender, _amount);
        
    }

    function unpledge(uint _id,uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        
        require(block.timestamp >= campaign.startAt,"Campain not yet started... ");
        require(block.timestamp < campaign.endAt,"CampainEnded... ");
        require(pledgedAmount[_id][msg.sender] >= _amount,"Insufficients tokens pledged...");

        // transfer funds to ERC20 token from this contract
        token.transfer(msg.sender, _amount);
        // Update the amount in pledgedAmount
        pledgedAmount[_id][msg.sender] -= _amount;

        // updated pledged field in campaign
        campaign.pledged -= _amount;

        emit Unpledge(_id, msg.sender, _amount);        
    }

    function claim(uint _id) external{

        Campaign storage campaign = campaigns[_id];
        require(campaign.creator == msg.sender,"Not a creator... ");
        require(block.timestamp > campaign.endAt,"Campain not yet Ended... ");
        require(campaign.pledged >= campaign.goal,"pledged < goal");
        require(!campaign.claimed,"Already Claimed");


        // transfer tokens to creator
        token.transfer(campaign.creator, campaign.pledged);
        // set claimed to true
        campaign.claimed = true;
        emit Claim(_id);

    }

    function cancel(uint _id) external {

        Campaign storage campaign = campaigns[_id];
        require(campaign.creator == msg.sender,"Not a creator... ");
        require(block.timestamp < campaign.startAt,"Campain already started... ");

        delete campaigns[_id];
        emit Cancel(_id);

    }

    function refund(uint _id) external {

        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt,"Campain not yet Ended... ");
        require(campaign.pledged < campaign.goal,"pledged > goal");
        require(!campaign.claimed,"Already Claimed");  

        uint bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);              

    }


}