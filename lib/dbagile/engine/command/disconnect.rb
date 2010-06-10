class DbAgile::Engine::Command::Disconnect < DbAgile::Engine::Command
        
  # Command's names
  names 'disconnect'
  
  # Command's signatures
  signature{}      
        
  # Command's synopsis
  synopsis "disconnect from the current database"
      
  # Executes the command on the engine
  def execute_1(engine)
    engine.disconnect
  end
        
end # class Quit