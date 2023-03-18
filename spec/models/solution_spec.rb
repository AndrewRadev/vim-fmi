require 'base64'
require 'rails_helper'

describe Solution do
  it "can find all the latest solutions for task" do
    task = create :task

    user1 = create :user
    user2 = create :user

    solution1 = create :solution, task: task, user: user1, created_at: 10.minutes.ago
    solution2 = create :solution, task: task, user: user2, created_at: 9.minutes.ago
    solution3 = create :solution, task: task, user: user1, created_at: 8.minutes.ago

    expect(Solution.latest_for_task(task.id)).to eq [solution3, solution2]
  end

  it "converts binary Vim key logs to readable keys" do
    encoded_key_log = 'aUZvb4BrbIBrbIBrbEJhcg0bgP1hgP1gWlqA/WA6cSEN'
    solution = create :solution, script: Base64.decode64(encoded_key_log)

    expect(solution.script_keys.join('')).to eq 'iFoo<Left><Left><Left>Bar<CR><Esc>ZZ:q!<CR>'
  end

  it "compacts sequences of arrows and mouse actions" do
    encoded_key_log = 'aUZvb4BrbIBrbIBrbEJhcg0bgP1hgP1gWlqA/WA6cSEN'
    solution = create :solution, script: Base64.decode64(encoded_key_log)

    expect(solution.compact_script_keys.join('')).to eq 'iFoo[3x<Left>]Bar<CR><Esc>ZZ:q!<CR>'

    solution.update_column(:script_keys, ['a', 'b', 'c'])
    expect(solution.compact_script_keys.join('')).to eq 'abc'

    solution.update_column(:script_keys, ['<Left>', '<Left>', '<Right>', '<Right>', '<Right>'])
    expect(solution.compact_script_keys.join('')).to eq '[2x<Left>][3x<Right>]'

    solution.update_column(:script_keys, ['<Left>', '<Left>', '<Right>', '<Left>', '<Left>'])
    expect(solution.compact_script_keys.join('')).to eq '[2x<Left>]<Right>[2x<Left>]'
  end

  it "shows warnings for mouse usage and arrows" do
    solution = create :solution

    solution.update_column(:script_keys, ['i', 'a', '<LeftMouse>', '<esc>'])
    expect(solution.warnings).to eq ['🐁']

    solution.update_column(:script_keys, ['<Left>', '<Left>', '<Right>', '<Left>', '<Left>'])
    expect(solution.warnings).to eq ['🏹']

    solution.update_column(:script_keys, ['<Left>', '<LeftMouse>'])
    expect(solution.warnings).to match_array ['🏹', '🐁']
  end
end
