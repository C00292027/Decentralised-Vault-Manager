// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./VaultManager.sol";

contract VaultManagerTest is Test {
    VaultManager public vaultManager;
    address public alice;


    function setUp() public {
        vaultManager = new VaultManager();
        alice = makeAddr("Alice");
    }

    function testAddVault() public {
         uint256 initialVaultsLength = vaultManager.getVaultsLength();
         assertEq(initialVaultsLength, 0);


        vm.prank(alice);
        uint256 newIndex = vaultManager.addVault(189);


        uint256 updatedVaultsLength = vaultManager.getVaultsLength();
         assertEq(updatedVaultsLength, initialVaultsLength + 1);


        (address owner, uint256 balance) = vaultManager.getVault(newIndex);
          assertEq(owner, alice);
          assertEq(balance, 0);
    }

    function testDepositAndWithdraw() public {
         vm.prank(alice);
         uint256 vaultIndex = vaultManager.addVault(333);


        uint256 initialBalance = address(this).balance;


          vm.prank(alice);
          vaultManager.deposit(vaultIndex);


        uint256 updatedBalance = address(this).balance;
        assert(updatedBalance > initialBalance);


         uint256 depositAmount = updatedBalance - initialBalance;


          vm.prank(alice);
          vaultManager.withdraw(vaultIndex, depositAmount);


         uint256 finalBalance = address(this).balance;
        assertEq(finalBalance, initialBalance);


         (address owner, uint256 balance) = vaultManager.getVault(vaultIndex);
           assertEq(owner, alice);
           assertEq(balance, 0);
    }

    function testGetMyVaults() public {
         uint256[] memory myVaults = vaultManager.getMyVaults();
         uint256 initialVaultsLength = vaultManager.getVaultsLength();

          assertEq(myVaults.length, 0);


           vm.prank(alice);
           vaultManager.addVault(444); 


            vm.prank(alice);
            vaultManager.addVault(99);


            vm.prank(makeAddr("Bob"));
            vaultManager.addVault(107);

         myVaults = vaultManager.getMyVaults();
         assertEq(myVaults.length, 2);


        vm.prank(makeAddr("Bob"));
         vaultManager.addVault(113);


        myVaults = vaultManager.getMyVaults();
         assertEq(myVaults.length, 2);


          vm.prank(alice);
         vaultManager.addVault(111);


          myVaults = vaultManager.getMyVaults();
         assertEq(myVaults.length, 3);
    }
}
