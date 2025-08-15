#!/usr/bin/env python3
"""
Simple test file for debugging
"""

def fibonacci(n):
    """Calculate fibonacci number"""
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

def main():
    """Main function for testing"""
    numbers = [1, 2, 3, 4, 5, 6, 7, 8]
    
    print("Testing debugging capabilities...")
    
    for num in numbers:
        try:
            result = fibonacci(num)
            print(f"fibonacci({num}) = {result}")
        except Exception as e:
            print(f"Error calculating fibonacci({num}): {e}")
    
    # Test exception handling
    try:
        division_result = 10 / 0
    except ZeroDivisionError as e:
        print(f"Caught division error: {e}")

if __name__ == "__main__":
    main()