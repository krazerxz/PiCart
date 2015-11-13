Given 'I am on the list index' do
  visit '/lists'
end

When 'I click the new list button' do
  click_on 'New List'
end

And 'I fill in the list details' do
  fill_in 'list_name', with: 'Shopping List'
  click_on 'Create List'
end

Then 'a list should be created' do
  expect(List.count).to eq 1
  expect(List.first.name).to eq 'Shopping List'
end
