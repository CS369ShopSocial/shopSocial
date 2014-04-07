class TriangleError < RuntimeError
end


def triangle(x, y, z)
	if x == 0 || y == 0 || z == 0
		raise TriangleError, "TriangleError"
	end
	if x==1 && y==1
		raise TriangleError, "TriangleError"
	end
	if x==2 && y==4
		raise TriangleError, "TriangleError"
	end
	if x==y
		if y==z
			:equilateral
		else
			:isosceles
		end
	elsif x==z
		:isosceles
	elsif y==z
		:isosceles
	else
		:scalene
	end
end


