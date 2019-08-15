package com.Brooks;

import java.awt.*;
import java.sql.Array;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;

public class RemoveDuplicatesfromSortedArray {

    // 方法1：将数组元素存进map去重， 然后返回map的数量即数组去重后的元素个数
    public static int removeDuplicates1(int[] nums) {

        HashMap<Integer,Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            if (!map.containsValue(nums[i])) {
                map.put(i, nums[i]);
            }
        }

        return map.size();
    }

    // 方法2：直接将数组元素存储进set，自然去重，然后返回set的大小即去重后数组元素的数量
    public static int removeDuplicates2(int[] nums) {

        HashSet<Integer> set = new HashSet();
        for (int num:nums) {
            set.add(num);
        }

        System.out.println(set);

        return set.size();
    }

    // 方法3：设置计数器，初始值为1，逐次比较相邻两个数字、不同则计数器+1，最后返回计数器数字即为数组中不同元素个数
    public static int removeDuplicates3(int[] nums) {
        if (nums.length<=0) return 0;

        int count = 1;
        for (int i = 0; i < nums.length-1; i++) {
            if (nums[i] != nums[i+1]){
                count++;
            }
        }

        return count;
    }

    // 方法1、2、3，都不是正确方案，题目本意是：返回长度的同时，要改变原数组的排列
    // 方法3：定义一个数组内不同元素的长度记录器、一个最近一次不相等的元素值OG，
    // 将数组内元素逐次和OG比较，不相等则将下一个元素值赋值给OG，也将此次不同的元素前移到当前targetIndex的位置。
    // 直到数组遍历完毕，得到期望值和改变排列后的原数组。
    public static int removeDuplicates4(int[] nums) {
        if (nums.length <= 0) return 0;

        int targetIndex = 1;
        int OG = nums[0];
        for (int i = 1; i < nums.length; i++) {
            if (OG != nums[i]){
                OG = nums[i];
                nums[targetIndex] = nums[i];
                targetIndex++;
            }
        }

        return targetIndex;
    }
}
