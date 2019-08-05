local Body = class("Body")

function Body:initialize(shape, entity, offset, callback)
    shape.entity = entity
    self.shape = shape
    self.offset = offset
    shape.callback = callback
end

return Body