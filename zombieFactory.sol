pragma solidity  >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";


contract ZombieFactory is Ownable {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    event NewZombie(uint zombieId, string name, uint dna);//event declared to notify front end

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days; //an amount of time a zombie has to wait after feeding or attacking before it's allowed to attack again

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping(uint => address) public zombieToOwner; //tracks who owns a zombie
    mapping(address => uint) ownerZombieCount; //tracks how many owned by user

    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) -1;
        zombieToOwner[id] = msg.sender; //assign ownership of zombie to whoever calls function
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1); //increment their owned zombie count
        emit NewZombie(id, _name, _dna);//event fired here
    } 
    
     
    function _generateRandomDna(string memory _str) private view returns (uint) {
        //keccak = https://bit.ly/3LRLDcA
        //abi = https://www.quicknode.com/guides/solidity/what-is-an-abi
        uint rand = uint(keccak256(abi.encodePacked(_str))); 
        return rand % dnaModulus;
    }
    
    //takes a name and uses it to generate a random zombie
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); //only allow sender to create zombie once
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}



