pragma solidity >=0.5.0 <0.6.0;


import "./zombiehelper.sol";

/**
 * The ZombieAttack is ZombieHelper contract does this and that...
 */
contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

/**
 * take the timestamp of now, the msg.sender, and an incrementing nonce (a number that is only ever used once, 
 * so we don't run the same hash function with the same input parameters twice 
 **/
  function randMod(uint _modulus) internal returns (uint) {
  	randNonce++;	
  	return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  } 

  function attack(uint _zombieId, uint _targetId) external {
  	
  }
  
}

