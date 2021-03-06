pragma solidity >=0.5.0 <0.6.0;

import "./zombieFactory.sol";
contract KittyInterface{
	function getKitty(uint256 _id) external view returns (
		bool isGestating,
	    bool isReady,
	    uint256 cooldownIndex,
	    uint256 nextActionAt,
	    uint256 siringWithId,
	    uint256 birthTime,
	    uint256 matronId,
	    uint256 sireId,
	    uint256 generation,
	    uint256 genes
	);
}


contract ZombieFeeding is ZombieFactory { //demonstrating inheritance

  	KittyInterface kittyContract;

  	modifier onlyOwnerOf(uint _zombieId) { 
  	 	require(msg.sender == zombieToOwner[_zombieId]); 
  	 	_; 
  	 }
  	  

  	//uses onlyOwner modifier from ownable.sol to prevent others from changing the contract
  	function setKittyContractAddress(address _address) external onlyOwner { //points to cryptoKitty address
  		kittyContract = KittyInterface(_address);
  	}

  	function _triggerCooldown(Zombie storage _zombie) internal {
  		_zombie.readyTime = uint32(now + cooldownTime);
  	}

  	//tells us whether enough time has passed since last time zombie fed
  	function _isReady(Zombie storage _zombie) internal view returns (bool) {
  		return (_zombie.readyTime <= now);  
  	}


	function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId){
		Zombie storage myZombie = zombies[_zombieId]; //create a pointer to index of owners zombie
		require(_isReady(myZombie)); //can only execute this function if cooldown time is over
		_targetDna = _targetDna % dnaModulus; //to only take last 16 digits
		uint newDna = (myZombie.dna + _targetDna) / 2; //calculate new zombies DNA
		if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
			newDna = newDna - newDna % 100 + 99;
			//adding 99 on last 2 digits of DNA to signify they are cats (bc cats have 9 lives)
			//Assume newDna is 334455. Then newDna % 100 is 55, so newDna - newDna % 100 is 334400. Finally add 99 to get 334499
		}
		_createZombie("NoName", newDna);
		_triggerCooldown(myZombie);
	}

	function feedOnKitty(uint _zombieId, uint _kittyId) public { //gets kitty genes from contract
		uint kittyDna;
		(,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); //receiving tenth item in getKitty which returns 10 items
		feedAndMultiply(_zombieId, kittyDna, "kitty");
	}
	
}


