module REPL where

import Expr
import Parsing

data LState = LState { vars :: [(Name, Lit)] }

initLState :: LState
initLState = LState []

-- Given a variable name and a value, return a new set of variables with
-- that name and value added.
-- If it already exists, remove the old value
--Should be working -Ewan
updateVars :: Name -> Lit -> [(Name, Lit)] -> [(Name, Lit)]
updateVars n i vars = filter (\x -> fst x /= n) vars ++ [(n,i)]

-- Return a new set of variables with the given name removed
--Mohak
dropVar :: Name -> [(Name, Lit)] -> [(Name, Lit)]
dropVar n = filter (\x -> fst x /= n) 

process :: LState -> Command -> IO ()
process st (Set var e) 
     = do let st' = updateVars 
          -- st' should include the variable set to the result of evaluating e
          repl st'
process st (Print e) 
     = do let st' = undefined
          -- Print the result of evaluation
          repl st'

-- Read, Eval, Print Loop
-- This reads and parses the input using the pCommand parser, and calls
-- 'process' to process the command.
-- 'process' will call 'repl' when done, so the system loops.

repl :: LState -> IO ()
repl st = do putStr ("> ")
             inp <- getLine
             case parse pCommand inp of
                  [(cmd, "")] -> -- Must parse entire input
                          process st cmd
                  _ -> do putStrLn "Parse error"
                          repl st