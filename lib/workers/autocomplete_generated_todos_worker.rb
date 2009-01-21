class AutocompleteGeneratedTodosWorker < BackgrounDRb::MetaWorker

  set_worker_name :autocomplete_generated_todos_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  def autocomplete()
    puts "..autocompleting generated Todos"
    todos = Todo.find(:all, :conditions => [ "wizardrule_id IS NOT ? AND due < ? AND state = ?", nil, Date.today, 'active'])
    todos.each do |t|
      t.complete! if t.wizardrule.autocomplete? 
    end
  end
end
