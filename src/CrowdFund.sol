// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrowdFund {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    uint256 public count;
    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    constructor(address _token) public {
        token = IERC20(_token);
    }

    function launch(
        uint256 _goal,
        uint32 _startAt,
        uint32 _endAt
    ) public {
        require(
            _startAt > block.timestamp,
            "Campaign cannot start in the past"
        );
        require(_endAt > _startAt, "Campaign cannot end before it starts");
        require(
            _endAt <= block.timestamp + 90 days,
            "Campaign cannot end more than 90 days from now"
        );

        count++;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
    }

    function cancel(uint256 _id) public {
        Campaign memory campaign = campaigns[_id];
        require(
            campaign.creator == msg.sender,
            "Only the creator can cancel the campaign"
        );
        require(
            campaign.startAt > block.timestamp,
            "Campaign cannot be canceled after it has started"
        );

        delete(campaigns[_id]);
    }


    
}
