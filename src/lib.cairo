%lang starknet

from starknet::context import get_caller_address
from starknet::storage import Storage
from starknet::u256 import U256, u256_add, u256_sub
from starknet::syscalls import emit_event

# Define storage variable to keep track of each user's points
@storage_var
func user_points(user: felt) -> u256:
end

# Event for adding points
@event
func PointsAdded(user: felt, amount: u256):
end

# Event for redeeming points
@event
func PointsRedeemed(user: felt, amount: u256):
end

# Function to add points to the user's balance
@external
func add_points(amount: u256):
    # Get the address of the caller
    let caller = get_caller_address()
    
    # Read the current balance
    let current_balance = user_points.read(caller)
    
    # Add the amount to the current balance
    let new_balance = u256_add(current_balance, amount)
    
    # Write the new balance to storage
    user_points.write(caller, new_balance)
    
    # Emit the PointsAdded event
    emit_event PointsAdded(caller, amount)
end

# Function to redeem points from the user's balance
@external
func redeem_points(amount: u256):
    # Get the address of the caller
    let caller = get_caller_address()
    
    # Read the current balance
    let current_balance = user_points.read(caller)
    
    # Ensure the user has enough points to redeem
    assert u256_sub(current_balance, amount) >= 0, 'Insufficient points to redeem'
    
    # Subtract the amount from the current balance
    let new_balance = u256_sub(current_balance, amount)
    
    # Write the new balance to storage
    user_points.write(caller, new_balance)
    
    # Emit the PointsRedeemed event
    emit_event PointsRedeemed(caller, amount)
end

# View function to check the user's points balance
@view
func get_points() -> u256:
    # Get the address of the caller
    let caller = get_caller_address()
    
    # Return the points balance of the caller
    return user_points.read(caller)
end
