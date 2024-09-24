def bubble_sort!(arr)
  loop do
    swap = false
    (0..arr.length - 2).each do |el|
      if arr[el] > arr[el + 1]
        arr[el], arr[el + 1] = arr[el + 1], arr[el]
        swap = true
      end
    end
    break unless swap
  end
end

array = [5, 3]
bubble_sort!(array)
p array == [3, 5]

array = [6, 2, 7, 1, 4]
bubble_sort!(array)
p array == [1, 2, 4, 6, 7]

array = %w(Sue Pete Alice Tyler Rachel Kim Bonnie)
bubble_sort!(array)
p array == %w(Alice Bonnie Kim Pete Rachel Sue Tyler)
