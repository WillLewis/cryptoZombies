pragma solidity  >=0.5.0 <0.6.0;

contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);//event declared to notify front end

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping(uint => address) public zombieToOwner; //tracks who owns a zombie
    mapping(address => uint) ownerZombieCount; //tracks how many owned by user

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) -1;
        zombieToOwner[id] = msg.sender; //assign ownership of zombie to whoever calls function
        ownerZombieCount[msg.sender]++; //increment their owned zombie count
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


