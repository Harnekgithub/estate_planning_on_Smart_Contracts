pragma solidity ^0.4.21;

contract Ownable {
    address owner = msg.sender;
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Mortal is Ownable {
    function kill() public onlyOwner {
        selfdestruct(msg.sender);
    }
}

contract Estate is Mortal {
    address beneficiary;
    modifier onlyBeneficiary {
        require(msg.sender == beneficiary);
        _;
    }

    uint256 waitingPeriodLength;
    uint256 endOfWaitingPeriod;
    modifier heartbeat {
        _;
        endOfWaitingPeriod = 10 ** 18;  // approximate age of universe
    }

    function Estate(address _beneficiary, uint256 _waitingPeriodLength)
        public
        heartbeat
    {
        beneficiary = _beneficiary;
        waitingPeriodLength = _waitingPeriodLength;
    }

    function deposit() public payable onlyOwner heartbeat { }

    function withdraw(uint256 amount) public onlyOwner heartbeat {
        msg.sender.transfer(amount);
    }

    event Challenge(uint256 timestamp);

    function assertDeath() public onlyBeneficiary {
        endOfWaitingPeriod = now + waitingPeriodLength;
        emit Challenge(now);
    }

    function claimInheritance(address newBeneficiary)
        public
        onlyBeneficiary
        heartbeat
    {
        require(now >= endOfWaitingPeriod);

        owner = msg.sender;
        beneficiary = newBeneficiary;
    }
}
