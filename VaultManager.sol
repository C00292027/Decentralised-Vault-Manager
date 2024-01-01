// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract VaultManager {

     struct Vault {
       address owner;
       uint256 balance;
  }

  Vault[ ] public vaults;
  mapping (address => uint256[ ] ) public VaultsByOwner;

    event VaultAdded(uint256 id, address owner);
    event VaultDeposit(uint256 id, address owner, uint256 amount);
    event VaultWithdraw(uint256 id, address owner, uint256 amount);


    modifier onlyOwner (uint256 vaultId)  {
         require(vaults[vaultId].owner == msg.sender);
        _;
    }

//adds a new vault to the VaultManager 
  function addVault() public returns (uint256 index) {
      Vault memory newVault = Vault(msg.sender, 0);
        uint256 vaultId = vaults.length;
        vaults.push(newVault);
        VaultsByOwner[msg.sender].push(vaultId);
        emit VaultAdded(vaultId, msg.sender);
        return vaultId;

  }

  function deposit(uint256 vaultId) public payable onlyOwner(vaultId){
      vaults[vaultId].balance += msg.value;
        emit VaultDeposit(vaultId, msg.sender, msg.value);


  }

  function withdraw(uint256  vaultId, uint256 amount) public onlyOwner(vaultId) {
           require(amount <= vaults[vaultId].balance, "Insufficient funds");
        vaults[vaultId].balance -= amount;
        payable(msg.sender).transfer(amount);
        emit VaultWithdraw(vaultId, msg.sender, amount);

  }

  function getVault(uint256 vaultId) public view returns (address owner, uint256 balance){
           owner = vaults[vaultId].owner;
        balance = vaults[vaultId].balance;


  }

  function getVaultsLength( ) public view returns  (uint256){
         return vaults.length;

  }

  function getMyVaults( ) public view returns (uint256[ ] memory) {
       return VaultsByOwner[msg.sender];
  }
 }
