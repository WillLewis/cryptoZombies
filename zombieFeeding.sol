pragma solidity >=0.5.0 <0.6.0;

import "./zombieFactory.sol";

contract ZombieFeeding is ZombieFactory { //demonstrating inheritance

	function feedAndMultiply(uint _zombieId, uint _targetDna) public {
		require(msg.sender == zombieToOwner[_zombieId]); //make sure owner owns this zombie
		Zombie storage myZombie = zombies[_zombieId]; //create a pointer to index of owners zombie
		_targetDna = _targetDna % dnaModulus; //to only take last 16 digits
		uint newDna = (myZombie.dna + _targetDna) / 2;
		_createZombie("NoName", newDna);

	}

}
