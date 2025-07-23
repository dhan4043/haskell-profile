--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
  }


main :: IO ()
main = hakyllWith config $ do
    match "fonts/*" $ do
        route   idRoute
        compile copyFileCompiler


    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler


    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler


    match "posts/*.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "projects/*.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler 
                >>= loadAndApplyTemplate "templates/post.html"    projectCtx
                >>= loadAndApplyTemplate "templates/default.html" projectCtx
                >>= relativizeUrls

    match "404.html" $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls


    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            projects <- recentFirst =<< loadAll "projects/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts)          `mappend`
                    listField "projects" projectCtx (return projects) `mappend`
                    constField "title" "Archives"                     `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["projects.html"] $ do
        route idRoute
        compile $ do
            projects <- recentFirst =<< loadAll "projects/*"
            let projectsCtx =
                    listField "projects" projectCtx (return projects) `mappend`
                    constField "title" "Projects"                     `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/projects.html" projectsCtx
                >>= loadAndApplyTemplate "templates/default.html"  projectsCtx
                >>= relativizeUrls

    match "index.md" $ do
        route $ setExtension "html"
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            projects <- recentFirst =<< loadAll "projects/*"
            let indexCtx =
                    listField "posts" postCtx (return posts)          `mappend`
                    listField "projects" projectCtx (return projects) `mappend`
                    constField "title" "David Han"                    `mappend`
                    defaultContext

            pandocCompiler
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls


    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
entryCtx :: String -> Context String
entryCtx entryType =
    constField "entry-type" entryType `mappend`
    dateField "date" "%d %b %Y"       `mappend`
    defaultContext

postCtx :: Context String
postCtx = entryCtx "post"

projectCtx :: Context String
projectCtx = entryCtx "project"
