pragma solidity >=0.5.0 <0.6.0; //very specific about this being at top of file w/ no extra space

import "./zombieattack.sol";
import "./erc721.sol";


/**
 * The ZombieOwnership is ZombieAttack contract does this and that...
 */
contract ZombieOwnership is ZombieAttack, ERC721 {
  
  mapping (uint => address) zombieApprovals;
  

  function balanceOf(address _owner) external view returns (uint256) {
    // 1. Return the number of zombies `_owner` has here
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    // 2. Return the owner of `_tokenId` here
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
  	ownerZombieCount[_to]++;
  	ownerZombieCount[_from]--;
  	zombieToOwner[_tokenId] = _to;
  	emit Transfer(_from, _to, _tokenId);
  	
  	
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
  	require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
  	_transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
  	zombieApprovals[_tokenId] = _approve;	

  }

}


