-- post-list.lua
function Pandoc(doc)
  local projects = doc.meta.projects
  if not projects then return doc end

  return doc:walk({
    Div = function(div)
      if div.identifier == 'projectslist' then
        local items = {}
        for _, item in ipairs(projects) do
          local title = pandoc.utils.stringify(item.name)
          local url =  "projects" .. "/" .. title .. "/"
          table.insert(items, { pandoc.Plain({ pandoc.Link(title, url) }) })
        end
        return pandoc.BulletList(items)
      end
    end
  })
end