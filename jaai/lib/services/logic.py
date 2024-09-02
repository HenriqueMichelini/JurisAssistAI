import re
import argparse

def sanitize_string(input_string):
    sanitized_string = input_string.lower()
    
    # Remove punctuation using regex
    sanitized_string = re.sub(r'[^\w\s]', '', sanitized_string)
    
    # Remove extra spaces
    sanitized_string = re.sub(r'\s+', ' ', sanitized_string).strip()
    
    return sanitized_string

def find_keywords_with_positions(input_string, keywords):
    keyword_positions = {}
    sanitized_string = sanitize_string(input_string)
    
    for keyword in keywords:
        keyword_positions[keyword] = []
        start = 0
        while start < len(sanitized_string):
            start = sanitized_string.find(keyword, start)
            if start == -1:
                break
            keyword_positions[keyword].append(start)
            start += len(keyword)  # Move past the current keyword to find subsequent occurrences
    
    return keyword_positions

def main():
    parser = argparse.ArgumentParser(description="Extract and find positions of keywords in a string.")
    parser.add_argument("input_string", type=str, help="The input string to search within.")
    parser.add_argument("keywords", type=str, nargs='+', help="The keywords to search for in the input string.")
    
    args = parser.parse_args()

    input_string = args.input_string
    keywords = args.keywords

    keyword_positions = find_keywords_with_positions(input_string, keywords)

    for keyword, positions in keyword_positions.items():
        if positions:
            print(f"Keyword: '{keyword}' found at positions: {positions}")
        else:
            print(f"Keyword: '{keyword}' not found.")

if __name__ == "__main__":
    main()
