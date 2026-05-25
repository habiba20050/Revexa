import subprocess
import re
import sys

def main():
    print("Running flutter analyze...")
    result = subprocess.run(["flutter.bat", "analyze"], capture_output=True, text=True, shell=True)
    lines = result.stdout.split('\n')
    
    fixes = {}
    
    for line in lines:
        if 'invalid_constant' in line or 'non_constant_list_element' in line or 'non_constant_default_value' in line:
            # error - Invalid constant value - lib\features\services\presentation\screens\service_detail_screen.dart:78:73 - invalid_constant
            parts = line.split(' - ')
            if len(parts) >= 4:
                file_info = parts[-2].strip()
                file_parts = file_info.split(':')
                if len(file_parts) == 3:
                    file_path = file_parts[0]
                    line_num = int(file_parts[1]) - 1 # 0-indexed
                    col_num = int(file_parts[2])
                    
                    if file_path not in fixes:
                        fixes[file_path] = []
                    fixes[file_path].append((line_num, col_num))

    print(f"Found {len(fixes)} files to fix.")
    
    for file_path, errors in fixes.items():
        with open(file_path, 'r', encoding='utf-8') as f:
            content_lines = f.readlines()
        
        # Sort errors in reverse order so modifying lines doesn't affect earlier positions on the same line
        errors.sort(reverse=True)
        
        for line_num, col_num in errors:
            # We need to find the nearest 'const ' before this position.
            # It could be on the same line or previous lines.
            found = False
            curr_line = line_num
            while curr_line >= 0 and not found:
                # If we go too far back (e.g., 20 lines) without finding const, stop.
                if line_num - curr_line > 20:
                    break
                    
                line_str = content_lines[curr_line]
                # find all 'const ' in line_str
                idx = line_str.rfind('const ')
                if idx != -1:
                    # remove it
                    content_lines[curr_line] = line_str[:idx] + line_str[idx+6:]
                    found = True
                curr_line -= 1
                
        with open(file_path, 'w', encoding='utf-8') as f:
            f.writelines(content_lines)
            
    print("Fixes applied.")

if __name__ == "__main__":
    main()
