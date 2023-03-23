// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract InsuranceSystem {
    mapping (uint => Policy) public policies;
    struct Policy {
        address owner;
        bool active;
        uint coverage;
    }
    mapping (uint => Claim) public claims;
    struct Claim {
        address policyOwner;
        uint policyCoverage;
        uint amount;
        bool approved;
    }

    function purchasePolicy(uint id, uint coverage) public payable {
        require(policies[id].active == false, "Policy already exists.");
        require(coverage > 0, "Coverage must be greater than zero.");
      
        policies[id] = Policy({
            owner: msg.sender,
            active: true,
            coverage: coverage
        });
    }


    function makeClaim(uint id, uint claimAmount) public{
        require(policies[id].active == true, "Policy does not exist.");
        require(claimAmount <= policies[id].coverage, "Claim amount exceeds policy coverage.");
        claims[id] = Claim({
            policyOwner: policies[id].owner,
            policyCoverage: policies[id].coverage,
            amount: claimAmount,
            approved: false
        });
    }

    function approveClaim(uint id) public {
        require(policies[id].active == true, "Policy does not exist.");
        require(claims[id].approved == false, "Claim has already been approved.");

        claims[id].approved = true;

        claims[id].policyOwner.transfer(claims[id].amount);
    }
    function getCoverage(uint id) public view returns (uint) {
        return policies[id].coverage;
    }
}

